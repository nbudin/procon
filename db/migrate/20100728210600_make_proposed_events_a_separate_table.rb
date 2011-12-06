class MakeProposedEventsASeparateTable < ActiveRecord::Migration
  class UntypedEvent < Event
    self.inheritance_column = nil
    
    belongs_to :registration_policy
    belongs_to :proposer, :class_name => "Person"
    belongs_to :parent, :class_name => "UntypedEvent"
  end

  def up
    create_table "proposed_events" do |t|
      t.string   "fullname", :null => false
      t.string   "shortname"
      t.string   "blurb",                    :limit => 4000
      t.string   "description",              :limit => 4000
      
      t.references :registration_policy
      t.references :proposer
      t.references :parent
      
      t.boolean  "attendees_visible", :default => false
      t.text     "proposed_timing"
      t.text     "proposal_comments"
      t.text     "proposed_location"
      t.text     "proposed_capacity_limits"
      
      t.timestamps
    end    
        
    UntypedEvent.where(:type => "ProposedEvent").find_each do |pe|
      say "Converting proposed event #{pe.fullname}"
    
      proposal = ProposedEvent.new
      %w(fullname shortname blurb description registration_policy proposer parent attendees_visible proposed_timing proposal_comments proposed_location proposed_capacity_limits created_at updated_at).each do |field|
        proposal.send("#{field}=", pe.send(field))
      end
      
      proposal.save!
      pe.delete
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
