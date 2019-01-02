require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create(email: 'test@test.com', nickname: 'Test', first_name: 'First', last_name: 'Super', birth_day: "01-01-1900", password:"123test" ) }
  let(:user1) { User.create(email: 'test1@test.com', nickname: 'Test1', first_name: 'First1', last_name: 'Super1', birth_day: "01-01-1900", password:"123test" ) }

  describe "when Task.new is called" do

  #otm
  it "should be ok with an associated post" do
    task = user.tasks.create(title:"test",text:"test")
    expect(task).to be_valid
  end

  it "validation Title shouldn't be blank" do
    task = user.tasks.create(title:"",text:"test")
    expect(task.errors.messages[:title]).to include("can't be blank")
  end

  it "validation Text shouldn't be blank" do
    task = user.tasks.create(title:"test",text:"")
    expect(task.errors.messages[:text]).to include("can't be blank")
  end

  it "validation Title should be unique only for exect User" do
    task = user.tasks.create(title:"test",text:"test")
    task1 = user.tasks.create(title:"test",text:"test")
    task2 = user1.tasks.create(title:"test",text:"test")
    expect(task).to be_valid
    expect(task1.errors.messages[:title]).to include("Title exists!")
    expect(task2).to be_valid
  end


  end #Validations

  describe "Tasks methods" do
    before do
      task = user.tasks.create(title:"test1",text:"test1", completed: true)
      task1 = user.tasks.create(title:"test2",text:"test2", completed: false)
      task2 = user.tasks.create(title:"test3",text:"test3")
    end

    it "should be 2 uncompleted tasks" do
      expect(user.tasks.uncompleted_tasks_count).to eq 2
    end

    it "should be 3 tasks" do
      expect(user.tasks.total_tasks_count).to eq (user.tasks.size)
    end

    it "should include uncompleted tasks" do
      expect(user.tasks.tasks_uncompleted).to include (user.tasks.where(completed: [false, nil]).first)
      expect(user.tasks.tasks_uncompleted.size).to eq 2
    end

    it "should include completed tasks" do
      expect(user.tasks.tasks_completed).to include (user.tasks.where(completed: true).first)
      expect(user.tasks.tasks_completed.size).to eq 1
    end

  end#Uncompleted tasks



end #Rspec
