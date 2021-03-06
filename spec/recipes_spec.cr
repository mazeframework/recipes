require "./spec_helper"

build_amber

describe "Compile available recipes" do
  it "compiles and tests base recipe" do
    generate_app recipe: "base"
    build_app.should be_true
    test_app.should be_true
  ensure
    cleanup
  end

  # it "compiles and tests orms/granite recipe" do
  #   generate_app recipe: "orms/granite"
  #   build_app.should be_true
  #   test_app.should be_true
  # ensure
  #   cleanup
  # end

  # TODO: crecto scaffolding is broken
  # the crecto builtin template is also broken
  # it "compiles and tests basic/crecto recipe" do
  #   generate_app recipe: "basic/crecto"
  #   build_app.should be_true
  # ensure
  #   cleanup
  # end

  it "compiles and tests react/preact_redux recipe" do
    generate_app recipe: "react/preact_redux"
    build_app.should be_true
    test_app.should be_true
  ensure
    cleanup
  end

  it "compiles and tests react/preact_streaming recipe" do
    generate_app recipe: "react/preact_streaming"
    build_app.should be_true
    test_app.should be_true
  ensure
    cleanup
  end

end
