class Node
  attr_accessor :left, :right, :data

  def initialize(value)
    @data = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :data

  def initialize(data)
    @data = data.uniq.sort
    @root = build_tree(data, 0, data.length - 1)
  end

  def build_tree(data, start, finish)
    return nil if start > finish

    mid = (start + finish) / 2
    root = Node.new(data[mid])
    root.left = build_tree(data, start, mid - 1)
    root.right = build_tree(data, mid + 1, finish)
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    node = Node.new(value)
    insert_node(@root, node)
  end

  def insert_node(node,element)
    if node.nil?
      node = element
    elsif node.data > element.data
      node.left = insert_node(node.left,element)
    else
      node.right = insert_node(node.right,element)
    end
    node
  end

  def height(curr = @root)
    return 0 if curr.nil?

    lheight = height(curr.left)
    rheight = height(curr.right)
    if lheight > rheight
      lheight + 1
    else
      rheight + 1
    end
  end

  def find(value)
    node = Node.new(value)
    find_node(@root,node)
  end

  def find_node(node,element)
    if node.nil?
      return nil
    elsif node.data == element.data
      return node
    elsif node.data < element.data
      find_node(node.right,element)
    else
      find_node(node.left,element)
    end
  end

  def delete(value, node = self.root)
    delete_node(value, node = self.root)
    node
end

  def delete_node(value, node = @root)
    if node == nil
      return nil
    end
    if node.data > value
        node.left = delete_node(value, node.left)
    elsif node.data < value
        node.right = delete_node(value, node.right)
    else
        if node.left != nil && node.right != nil
            temp = node
            min_of_right_subtree = find_min(node.right)
            node.data = min_of_right_subtree.value
            node.right = delete_node(min_of_right_subtree.value, node.right)
        elsif node.left != nil
            node = node.left
        elsif node.right != nil
            node = node.right
        else
            node = nil
        end
    end
    return node
  end

  def inorder(node = @root, &block)
    return nil if node.nil?

    yield node
    preorder(node.left, &block)
    preorder(node.right, &block)
  end
  
  def preorder(node  = @root,&block)
    return nil if node.nil?
    
    inorder(node.left, &block)
    yield node
    inorder(node.right, &block)
  end

  def balanced?(node = @root)
    return (height(node.left) - height(node.right)).abs <= 1
  end

  def postorder(node = @root, &block)
    return nil if node.nil?

    postorder(node.left, &block)
    postorder(node.right, &block)
    yield node
  end


  def level_order(node = @root,&block)
    queue = []
    queue.push node
    while !queue.empty? do 
      node = queue.shift
      yield node
      unless node.left.nil?
        queue.push node.left
      end
      unless node.right.nil?
        queue.push node.right
      end
    end
  end

  def depth(value)
    node = Node.new(value)
    curr = root
    count = 0 
    until curr.nil? || (node.data == curr.data)
      count += 1
      if value < curr.data
        curr = curr.left
      else
        curr = curr.right
      end
    end
    count
  end

  def rebalance
    arr = []
    level_order{|i| arr.push i.data}
    @root = build_tree(arr.sort,0,arr.length-1)
  end
end


t1 = Tree.new Array.new(15) { rand(1..100) }

t1.pretty_print

puts t1.balanced?

puts (t1.level_order {|i| print i.data.to_s + ' '})
puts t1.preorder{|i| print i.data.to_s + ' '}
puts t1.postorder{|i| print i.data.to_s + ' '}
puts t1.inorder{|i| print i.data.to_s + ' '}

t1.insert(112)
t1.insert(115)
t1.insert(101)

t1.pretty_print

puts t1.balanced?

t1.rebalance

t1.pretty_print

puts t1.balanced?

puts t1.level_order{|i| print "#{i.data} "}
puts t1.preorder{|i| print "#{i.data} "}
puts t1.postorder{|i| print "#{i.data} "}
puts t1.inorder{|i| print "#{i.data} "}