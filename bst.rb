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

  def insert(value,curr = @head)
    node = Node.new(value)
    return node if curr.nil?
    if value == curr.value
      puts "Value Already Exists"
      return nil
    elsif value < curr.value
      curr.left = insert(value,curr.left)
    elsif value > curr.value
      curr.right = insert(value,curr.right)
    end
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

  

  def delete(node, value)
    node if node.nil?
    if node.data > value
      node.left = delete(node.left,value)
      node
    elsif node.data < value
      node.right = delete(node.right,value)
    end
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
    return height(node.left) == height(node.right)
  end

  def postorder(node = @root, &block)
    return nil if node.nil?

    postorder(node.left, &block)
    postorder(node.right, &block)
    yield node
  end

  def level_order(node = @root, &block)
    return nil if node.nil?

    queue = []
    queue << node
    until queue.empty?
      node = queue.shift(1)
      queue.flatten
      yield node
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end
  end
end


t1 = Tree.new [1]
t1.insert 1
t1.pretty_print