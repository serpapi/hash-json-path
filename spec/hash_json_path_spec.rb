require "spec_helper"

describe HashJsonPath do
  before do 
    @hash = {
      a: {
        b: {
          c: 10
        },
        c: 20,
        d: [
          {e: 30},
          {f: 40}
        ]
      }
    }
  end

  describe "get" do
    it "returns the value of the nested path"  do
      [
        ["a[b][c]", 10],
        ["a[d][1][f]", 40],
      ].each do |path, value|
        _(HashJsonPath.on(@hash).get(path)).must_equal value
      end
    end

    it "returns nil if the path is not found" do
      _(HashJsonPath.on(@hash).get("invalid path")).must_be_nil
    end

    describe "imcompatible access key type" do
      it "raises an error using #get" do
        assert_raises(TypeError) do 
          # 1 should be an integer as it is an array access key,
          # but in this case it is a symbol
          HashJsonPath.on(@hash).get("a[d]['1'][f]")
        end
      end
  
      it "won't raises any error using #safe_get, nil is returned" do
        _(HashJsonPath.on(@hash).safe_get("a[d]['1'][f]")).must_be_nil
      end
    end
  end

  describe "set" do
    it "sets the value of the nested path" do
      hash = HashJsonPath.on(@hash).set("a[b][c]", { x: 100 })
      _(hash.get("a[b][c]")).must_equal({ x: 100 })
    end

    it "raises an error if the path is empty" do
      assert_raises(Exception) do 
        HashJsonPath.on(@hash).set("", { x: 100 })
      end
    end
  end

  describe "merge" do
    it "merges the provided value into existing hash" do
      hash = HashJsonPath.on(@hash).merge("a[b]", { x: 100 })
      _(hash.get("a[b]")).must_equal({ c: 10, x: 100 })
    end

    it "raises an error if the path is empty" do
      assert_raises(Exception) do 
        HashJsonPath.on(@hash).merge("", { x: 100 })
      end
    end

    it "raises an error if the provided value is not a hash" do
      assert_raises(Exception) do 
        HashJsonPath.on(@hash).merge("a[b]", 100)
      end
    end

    it "raises an error if the target leaf is not a hash" do
      assert_raises(Exception) do 
        HashJsonPath.on(@hash).merge("a[b][c]", { x: 100 })
      end
    end
  end

  describe "preprend" do
    it "prepend the provided value into existing hash" do
      hash = HashJsonPath.on(@hash).prepend("a[b]", { x: 100 })
      _(hash.get("a[b]")).must_equal({ x: 100, c: 10 })
    end

    it "raises an error if the path is empty" do
      assert_raises(Exception) do 
        HashJsonPath.on(@hash).preprend("", { x: 100 })
      end
    end

    it "raises an error if the provided value is not a hash" do
      assert_raises(Exception) do 
        HashJsonPath.on(@hash).preprend("a[b]", 100)
      end
    end

    it "raises an error if the target leaf is not a hash" do
      assert_raises(Exception) do 
        HashJsonPath.on(@hash).preprend("a[b][c]", { x: 100 })
      end
    end
  end

  describe "custom separator" do
    it "uses the provided separator" do
      hash = HashJsonPath.on(@hash).useSeparatorRegex(/[^\/]+/).set("a/b/c", { x: 100 })
      _(hash.get("a/b/c")).must_equal({ x: 100 })
    end
  end
end