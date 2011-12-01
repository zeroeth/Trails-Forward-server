require 'spec_helper'
require 'lib/matrix_utils_test'

RSpec::Matchers.define :equal_matrix do |goal|
  match do |target|
    target.eq(goal).all?
  end
end

describe MatrixUtilsTest, :fast, "#outputMatrix" do
  let(:matrix_utils_test) { MatrixUtilsTest.new }
  it "returns appropriate result for uniform matrix" do
    test_matrix = NArray.byte(5,5)
    test_matrix.fill!(4)
    goal_matrix = NArray.byte(5,5)
    goal_matrix.fill!(0)
    matrix_utils_test.test(test_matrix).should equal_matrix(goal_matrix)
  end

  context "test matrix" do
    describe "#test" do
      subject { matrix_utils_test.test(test_matrix) }
      after { subject.should equal_matrix(goal_matrix) }

      context "returns appropriate result for checkerboard martrix" do
        let(:test_matrix) { NArray[[1,2,1,2,1],[2,1,2,1,2],[1,2,1,2,1],[2,1,2,1,2],[1,2,1,2,1]] }
        let(:goal_matrix) { NArray[[0,1,2,3,4],[5,6,7,8,9],[10,11,12,13,14],[15,16,17,18,19],[20,21,22,23,24]] }
      end

      context "returns appropriate result for asymetric striped martrix" do
        let(:test_matrix) { NArray[[1,2,3,2],[1,2,3,2],[1,2,3,2],[1,2,3,2],[1,2,3,2],[1,2,3,2],[1,2,3,2]] }
        let(:goal_matrix) { NArray[[0,1,2,3],[0,1,2,3],[0,1,2,3],[0,1,2,3],[0,1,2,3],[0,1,2,3],[0,1,2,3]] }
      end

      context "returns appropriate result for 3 region swirl matrix" do
        let(:test_matrix) { NArray[[111,111,111,111,111],[4,4,4,4,111],[111,111,111,4,111],[111,4,4,4,111],[111,4,111,4,111],[111,4,4,4,111],[111,111,111,111,111]] }
        let(:goal_matrix) { NArray[[0,0,0,0,0],[1,1,1,1,0],[0,0,0,1,0],[0,1,1,1,0],[0,1,4,1,0],[0,1,1,1,0],[0,0,0,0,0]] }
      end


      context "returns appropriate result for 5x5 divided by diagonal" do
        let(:test_matrix) { NArray[[7,4,4,4,4],[4,7,4,4,4],[4,4,7,4,4],[4,4,4,7,4],[4,4,4,4,7]] }
        let(:goal_matrix) { NArray[[0,1,1,1,1],[2,3,1,1,1],[2,2,4,1,1],[2,2,2,5,1],[2,2,2,2,6]] }
      end
    end

    it "returns appropriate result for 5x5 divided by diagonal perimeter matrix" do
      test_matrix = NArray[[7,4,4,4,4],[4,7,4,4,4],[4,4,7,4,4],[4,4,4,7,4],[4,4,4,4,7]]
      goal_matrix = NArray[[1,1,0,0,0],[1,1,1,0,0],[0,1,1,1,0],[0,0,1,1,1],[0,0,0,1,1]]
      matrix_utils_test.test_Perimeter(test_matrix).should equal_matrix(goal_matrix)
    end


    it "returns appropriate result for 5x5 perimeter matrix" do
      test_matrix = NArray[[7,4,4,4,4],[4,7,4,4,4],[4,4,7,4,4],[4,4,4,7,4],[4,4,4,4,7]]
      goal_matrix = NArray[[1,1,1,1,1],[1,0,0,0,1],[1,0,0,0,1],[1,0,0,0,1],[1,1,1,1,1]]
      matrix_utils_test.test_bwperim(test_matrix).should equal_matrix(goal_matrix)
      test_matrix = NArray[[1,1,0,0,0],[1,1,1,0,0],[0,1,1,1,0],[0,0,1,1,1],[0,0,0,1,1]]
      goal_matrix = NArray[[1,1,0,0,0],[1,0,1,0,0],[0,1,0,1,0],[0,0,1,0,1],[0,0,0,1,1]]
      matrix_utils_test.test_bwperim(test_matrix).should equal_matrix(goal_matrix)
    end


    it "returns approrpiate result for andvanced test output" do
      test_matrix = NArray[[1,1,1],[1,1,2],[2,2,2]]
      goal_matrix = [ [[0,0],[1,0],[2,0],[0,1],[1,1]] , [[2,1],[0,2],[1,2],[2,2]] ]
      sizeGoal = [3,3]
      matrix_utils_test.test_New(test_matrix).PixelIdxList.should == goal_matrix
      matrix_utils_test.test_New(test_matrix).ImageSize.should == sizeGoal
      matrix_utils_test.test_New(test_matrix).NumObjects.should == 2
    end

    it "returns appropriate result for 3 region swirl matrix with lowest labels" do
      test_matrix = NArray[[111,111,111,111,111],[4,4,4,4,111],[111,111,111,4,111],[111,4,4,4,111],[111,4,111,4,111],[111,4,4,4,111],[111,111,111,111,111]]
      goal_matrix = NArray[[0,0,0,0,0],[1,1,1,1,0],[0,0,0,1,0],[0,1,1,1,0],[0,1,2,1,0],[0,1,1,1,0],[0,0,0,0,0]]
      matrix_utils_test.test_Label(test_matrix).should equal_matrix(goal_matrix)
    end


    it "Passes the dreaded Chickadeee test" do
      test_matrix = NArray[ [0,0,0,1,1,1], [1,1,0,0,0,1], [1,1,0,0,1,1], [0,0,1,0,0,1], [0,1,1,0,0,0], [1,1,1,1,1,0], [1,1,1,1,0,0] ]
      goal_matrix = NArray[ [0,0,0,1,1,1], [0,0,0,0,0,1], [0,0,0,0,1,1], [0,0,1,0,0,1], [0,1,1,0,0,0], [1,1,1,1,1,0], [1,1,1,1,0,0] ]
      matrix_utils_test.test_Chickadee(test_matrix).outputMatrix.should equal_matrix(goal_matrix)
      matrix_utils_test.test_Chickadee(test_matrix).count.should == 19
    end

    it "Passes the warbler test with perimeters" do
      test_matrix = NArray[ [0,0,0,1,1,1], [1,1,0,0,0,1], [1,1,0,0,1,1], [0,0,1,0,0,1], [0,1,1,0,0,0], [1,1,1,1,1,0], [1,1,1,1,0,0] ]
      goal_matrix = NArray[ [0,0,0,0,0,1], [0,0,0,0,0,0], [0,0,0,0,0,1], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,1,1,0,0,0], [1,1,1,0,0,0] ]
      matrix_utils_test.test_Warbler(test_matrix).outputMatrix.should equal_matrix(goal_matrix)
      matrix_utils_test.test_Warbler(test_matrix).count.should == 7
    end
  end
end
