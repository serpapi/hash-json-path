class HashJsonPath
  SEPERATOR_REGEX = /[^\[|^\]]+/ # e.g. local_results[0][1] => ["local_results", "0", "1"]

  def self.on(hash)
    new(hash)
  end

  def initialize(hash, separator_regex = SEPERATOR_REGEX)
    @hash = hash
    @separator_regex = separator_regex
  end

  def use_separator_regex(separator_regex)
    @separator_regex = separator_regex
    self
  end

  def value
    @hash
  end

  def get(path)
    @hash.dig(*access_keys(path))
  end

  def safe_get(path)
    get(@hash, path) rescue nil
  end
  
  def set(path, value)
    raise "Empty path is not allowed" if path.nil? || path.empty?

    *ancestors, leaf = access_keys(path)
    tampered_hash = ancestors.empty? ? @hash : @hash.dig(*ancestors)
    tampered_hash[leaf] = value
    self
  end

  def merge(path, hash_value)
    raise "Empty path is not allowed" if path.nil? || path.empty?
    raise "Value must be a Hash" unless hash_value.is_a?(Hash)

    *ancestors, leaf = access_keys(path)
    tampered_hash = ancestors.empty? ? @hash : @hash.dig(*ancestors)
    raise "Trying to merge a non hash value" unless tampered_hash[leaf].is_a?(Hash)
    tampered_hash[leaf] = tampered_hash[leaf].merge(hash_value)
    self
  end

  def prepend(path, hash_value)
    raise "Empty path is not allowed" if path.nil? || path.empty?
    raise "Value must be a Hash" unless hash_value.is_a?(Hash)

    *ancestors, leaf = access_keys(path)
    tampered_hash = ancestors.empty? ? @hash : @hash.dig(*ancestors)
    raise "Trying to merge with a non hash value" unless tampered_hash[leaf].is_a?(Hash)
    tampered_hash[leaf] = hash_value.merge(tampered_hash[leaf])
    self
  end

  private

  def access_keys(path)
    path.scan(@separator_regex).map{|key| Integer(key) rescue key.to_sym }
  end
end