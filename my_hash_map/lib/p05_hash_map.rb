require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_reader :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store.each do |linked_list|
      if linked_list.include?(key)
        return true
      end
    end
    false
  end

  def set(key, val)
    if bucket(key).include?(key)
      bucket(key).update(key,val)
    else
      @count += 1
      if @count >= num_buckets
        resize!
      end
      bucket(key).append(key,val)
    end
  end

  def get(key)
    if bucket(key).include?(key)
      bucket(key).get(key)
    end
  end

  def delete(key)
    if bucket(key).include?(key)
      bucket(key).remove(key)
    end
    @count -= 1
  end

  def each(&prc)
    each do |linked_list|
      unless linked_list.empty?
        linked_list.each(&prc)
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    oldstore = @store
    @store = Array.new(num_buckets * 2){ LinkedList.new }
    @count = 0
    oldstore.each do |linked_list|
      linked_list.each do |link|
        bucket(link.key).append(link.key,link.val)
      end
    end
    @store
  end

  def bucket(key)
    @store[key.hash % num_buckets]
    # optional but useful; return the bucket corresponding to `key`
  end
end
