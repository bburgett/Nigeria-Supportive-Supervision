require File.dirname(__FILE__) + '/../spec_helper'

describe Project do
  context "a user is logged in" do
    before(:each) do
      @current_user      = Factory(:user)
    end

    describe "creating a project record" do
      subject { Factory(:project) }
      
      it { should be_valid }
      it { should validate_presence_of(:name) }
      it { should allow_value(123.45).for(:budget) }
      it { should allow_value(123.45).for(:spend) }
      it { should allow_value(123.45).for(:entire_budget) }
      # these dont work since the setter methods automatically hose 
      # non-decimals
      #it { should_not allow_value("blah").for(:budget) }
      #it { should_not allow_value("blah").for(:spend) }
      #it { should_not allow_value("blah").for(:entire_budget) }
    end
    
    describe "assigning funding flows" do
      it "should have no assigned funding flows on creation" do
        pending  # see http://www.pivotaltracker.com/story/show/4925498
        project = Factory(:project)
        project.funding_flows.should be_empty
      end
    
      it "should assign a valid funding flow" do
        pending # see http://www.pivotaltracker.com/story/show/4925498
        project = Factory(:project) 
        flow    = Factory(:funding_flow, :from => Factory(:organization), :to => Factory(:organization))
        project.funding_flows << flow
        project.funding_flows.should have(1).item
      end
    end
    
    context "commentable" do
      describe "commenting on a project" do
        it "should assign to a project" do
          project     = Factory(:project)
          comment     = Factory(:comment)
          project.comments << comment
          project.comments.should have(1).item
          project.comments.first.should == comment
        end
      end
    end
    
    context "funding sources and outflows" do
      before(:each) do
        @our_org      = Factory(:organization)
        @other_org    = Factory(:organization)
        @project      = Factory(:project)
      end

      describe "getting who provided money to us (funding sources)" do
        it "should return a sole funding source" do  
          flow      = Factory(:funding_flow, :from => @other_org, :to => @our_org)
          @project.funding_flows << flow
          @project.funding_sources.should have(1).item
          @project.funding_sources.first.should == @other_org
        end    
      end
    
      describe "getting who we gave money to (the 'providers' we gave to)" do
        it "should return a sole organization" do
          flow         = Factory(:funding_flow, :from => @our_org, :to => @other_org)
          @project.funding_flows << flow
          # GR: 'providers' doesnt make a lot of sense from this perspective - our domain model a bit off?
          @project.providers.should have(1).item
          @project.providers.first.should == @other_org            
        end
      
        it "should return a sole organization we sent money to via the flows API" do
          flow         = Factory(:funding_flow, :from => @our_org, :to => @other_org, :project => @project)
          @project.providers.first.should == @other_org
        end
      end
    end
  end
end
