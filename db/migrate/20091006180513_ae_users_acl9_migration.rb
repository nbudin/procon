class AeUsersAcl9Migration< ActiveRecord::Migration
  def self.preload_all_models 
    # Preload all models, to make sure we know all the permissioned classes
    Dir.glob(File.join(Rails.root, "app", "models", "**", "*.rb")).each do |model|
      require model
    end
  end
  
  def self.up
    create_table :roles do |t|
      t.string "name"
      t.string "authorizable_type"
      t.integer "authorizable_id"
      t.timestamps
    end
    
    preload_all_models
    
    # Populate roles from existing permission names
    superadmin = Role.create!(:name => "superadmin")
    blanket_roles = {}
    AeUsers.permissioned_classes.each do |klass|
      klass.permission_names.each do |perm_name|
        klass.all.each do |obj|
          Role.create!(:name => perm_name, :authorizable => obj)
        end
        blanket_roles[klass] = Role.create!(:name => "#{perm_name}_#{klass.name.tableize}")
      end
    end
    
    create_table :people_roles, :id => false do |t|
      t.integer "person_id"
      t.integer "role_id"
    end
    
    ActiveRecord::Base.connection.execute("DELETE FROM permissions WHERE permissioned_type = 'Role'")
    
    ActiveRecord::Base.connection.execute("INSERT INTO people_roles (person_id, role_id)
                                         SELECT person_id, roles.id FROM permissions
                                         LEFT JOIN roles ON
                                          (roles.name = permissions.permission
                                           AND authorizable_type = permissioned_type
                                           AND authorizable_id = permissioned_id)
                                         WHERE person_id IS NOT NULL
                                         AND permissioned_type IS NOT NULL
                                         AND permissioned_id IS NOT NULL
                                         AND permission IS NOT NULL")
    
    ActiveRecord::Base.connection.execute("INSERT INTO people_roles (person_id, role_id)
                                         SELECT person_id, #{superadmin.id} FROM permissions
                                         WHERE person_id IS NOT NULL
                                         AND permissioned_type IS NULL
                                         AND permissioned_id IS NULL
                                         AND permission IS NULL")
  
    blanket_roles.values.each do |role|
      ActiveRecord::Base.connection.execute("INSERT INTO people_roles (person_id, role_id)
                                           SELECT person_id, #{role.id} FROM permissions
                                           WHERE person_id IS NOT NULL
                                           AND permissioned_type IS NULL
                                           AND permissioned_id IS NULL
                                           AND permission = #{ActiveRecord::Base.connection.quote role.name}")
    end
    
    create_table :groups_roles, :id => false do |t|
      t.integer "group_id"
      t.integer "role_id"
    end
    
    ActiveRecord::Base.connection.execute("INSERT INTO groups_roles (group_id, role_id)
                                         SELECT role_id, roles.id FROM permissions
                                         LEFT JOIN roles ON
                                          (roles.name = permissions.permission
                                           AND authorizable_type = permissioned_type
                                           AND authorizable_id = permissioned_id)
                                         WHERE role_id IS NOT NULL
                                         AND permissioned_type IS NOT NULL
                                         AND permissioned_id IS NOT NULL
                                         AND permission IS NOT NULL")
    
    ActiveRecord::Base.connection.execute("INSERT INTO groups_roles (group_id, role_id)
                                         SELECT role_id, #{superadmin.id} FROM permissions
                                         WHERE role_id IS NOT NULL
                                         AND permissioned_type IS NULL
                                         AND permissioned_id IS NULL
                                         AND permission IS NULL")
  
    blanket_roles.values.each do |role|
      ActiveRecord::Base.connection.execute("INSERT INTO groups_roles (group_id, role_id)
                                           SELECT role_id, #{role.id} FROM permissions
                                           WHERE role_id IS NOT NULL
                                           AND permissioned_type IS NULL
                                           AND permissioned_id IS NULL
                                           AND permission = #{ActiveRecord::Base.connection.quote role.name}")
    end
    
    drop_table :permissions
  end
  
  def self.role_to_permissions(perm_name, permissioned, role)
    quoted_perm_name = perm_name.nil? ? "NULL" : ActiveRecord::Base.connection.quote(perm_name)
    sql_permissioned_id = permissioned.nil? ? "NULL" : permissioned.id.to_s
    quoted_permissioned_type = permissioned.nil? ? "NULL" : ActiveRecord::Base.connection.quote(permissioned.class.name)
    
    ActiveRecord::Base.connection.execute("INSERT INTO permissions
                                           (person_id, permission, permissioned_id, permissioned_type)
                                           SELECT person_id, #{quoted_perm_name},
                                                  #{sql_permissioned_id}, #{quoted_permissioned_type}
                                           FROM people_roles
                                           WHERE role_id = #{role.id}")
    
    ActiveRecord::Base.connection.execute("INSERT INTO permissions
                                           (role_id, permission, permissioned_id, permissioned_type)
                                           SELECT group_id, #{quoted_perm_name},
                                                  #{sql_permissioned_id}, #{quoted_permissioned_type}
                                           FROM groups_roles
                                           WHERE role_id = #{role.id}")
  end

  def self.down
    create_table :permissions do |t|
      t.column :role_id, :integer
      t.column :person_id, :integer
      t.column :permission, :string
      t.column :permissioned_id, :integer
      t.column :permissioned_type, :string
    end
    
    role_to_permissions nil, nil, Role.find_by_name("superadmin")
    
    preload_all_models
    AeUsers.permissioned_classes.each do |klass|
      klass.permission_names.each do |perm_name|
        blanket_role = Role.find_by_name("#{perm_name}_#{klass.name.tableize}")
        role_to_permissions blanket_role.name, nil, blanket_role
      end
    end
    
    Role.all(:conditions => "authorizable_id IS NOT NULL and authorizable_type IS NOT NULL").each do |role|
      role_to_permissions role.name, role.authorizable, role
    end
    
    drop_table :groups_roles
    drop_table :people_roles
    drop_table :roles
  end
end