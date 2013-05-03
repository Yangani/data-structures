RedBlackTree = require '../RedBlackTree'

# Shorthand for logging tree
l = (x) -> console.log require('util').inspect(x, true, 1024)

fill = (rbt) ->
    ###
                8
        3               13
    1       6       10       14
        4       7
    ###
    rbt.add 8
    rbt.add 3
    rbt.add 10
    rbt.add 1
    rbt.add 6
    rbt.add 14
    rbt.add 4
    rbt.add 7
    rbt.add 13

Queue = require '../Queue'
validate = (rbt, treeStructure) ->
    validNodeIndex = 0
    treeQueue = new Queue([rbt.root])
    while treeQueue.length isnt 0
        currentNode = treeQueue.dequeue()
        expect(currentNode.value).toBe treeStructure[validNodeIndex]
        if currentNode.leftChild?
            treeQueue.enqueue currentNode.leftChild
        if currentNode.rightChild?
            treeQueue.enqueue currentNode.rightChild
        validNodeIndex++
    expect(validNodeIndex).toBe treeStructure.length

describe "Creation", ->
    rbt = new RedBlackTree()
    it "should make an empty root", ->
        expect(rbt.root).toBeUndefined()
    rbt2 = new RedBlackTree([8, 3, 10, 1, 6])
    it "should initialize a tree with the array passed", ->
        validate rbt2, [8, 3, 10, 1, 6]

describe "Add", ->
    rbt = new RedBlackTree()
    it "should return the node value", ->
        expect(rbt.add 1).toBe 1
        expect(rbt.add undefined).toBeUndefined()
        expect(rbt.add "item").toBe "item"
    rbt2 = new RedBlackTree()
    it "should add the first node as the root", ->
        rbt2.add 8
        validate rbt2, [8]
    # The next few cases are manually checked. validate doesn't tell about
    # position. Could improve validate by making it accept a more concise
    # structure as parameter, but so far the models degrade readability.
    it "should add a node as left child of root", ->
        rbt2.add 3
        expect(rbt2.root.leftChild.value).toBe 3
        expect(rbt2.root.leftChild.parent.value).toBe 8
    it "should add a node as right child of root", ->
        rbt2.add 10
        expect(rbt2.root.rightChild.value).toBe 10
        expect(rbt2.root.rightChild.parent.value).toBe 8
    it "should add 6 as 3's right child", ->
        rbt2.add 6
        expect(rbt2.root.leftChild.rightChild.value).toBe 6
        expect(rbt2.root.leftChild.rightChild.parent.value).toBe 3
    it "should add 14 as 10's right child", ->
        rbt2.add 14
        expect(rbt2.root.rightChild.rightChild.value).toBe 14
        expect(rbt2.root.rightChild.rightChild.parent.value).toBe 10
    it "should add 4 as 8's left child and rearrange 3 to be 4's left child and 6 to be 4's right child", ->
        rbt2.add 4
        expect(rbt2.root.leftChild.value).toBe 4
        expect(rbt2.root.leftChild.leftChild.value).toBe 3
        expect(rbt2.root.leftChild.rightChild.value).toBe 6
    it "should add 13 as 8's child child and rearrange 10 to be 13's left child and 14 to be 13's right child", ->
        rbt2.add 13
        expect(rbt2.root.rightChild.value).toBe 13
        expect(rbt2.root.rightChild.leftChild.value).toBe 10
        expect(rbt2.root.rightChild.rightChild.value).toBe 14
    it "should add 7 as 6's right child", ->
        rbt2.add 7
        expect(rbt2.root.leftChild.rightChild.rightChild.value).toBe 7
        expect(rbt2.root.leftChild.rightChild.rightChild.parent.value).toBe 6
    it "should add 1 as 3's left child", ->
        rbt2.add 1
        expect(rbt2.root.leftChild.leftChild.leftChild.value).toBe 1
        expect(rbt2.root.leftChild.leftChild.leftChild.parent.value).toBe 3
    it "shouldn't accept duplicates and return undefined", ->
        rbt2.add 1
        rbt2.add 7
        rbt2.add 6
        rbt2.add 14
        rbt2.add 3
        rbt2.add 13
        rbt2.add 8
        rbt2.add 4
        rbt2.add 10
        validate rbt2, [8, 4, 13, 3, 6, 10, 14, 1, 7]

describe "Find", ->
    rbt = new RedBlackTree()
    it "should return nothing in an empty tree", ->
        expect(rbt.has 1).toBeFalsy()
        expect(rbt.has undefined).toBeFalsy()
    it "should return a node if it's found", ->
        fill rbt
        rbt.add 1
        expect(rbt.has 1).toBeTruthy()
        rbt.add 7
        expect(rbt.has 7).toBeTruthy()
        rbt.add 6
        expect(rbt.has 6).toBeTruthy()
        rbt.add 14
        expect(rbt.has 14).toBeTruthy()
        rbt.add 3
        expect(rbt.has 3).toBeTruthy()
        rbt.add 13
        expect(rbt.has 13).toBeTruthy()
        rbt.add 8
        expect(rbt.has 8).toBeTruthy()
        rbt.add 4
        expect(rbt.has 4).toBeTruthy()
        rbt.add 10
        expect(rbt.has 10).toBeTruthy()
    it "should has undefined if it's a node", ->
        rbt.add undefined
        expect(rbt.has undefined).toBeTruthy()

describe "Peek minimum", ->
    rbt = new RedBlackTree()
    it "should return undefined if the tree's empty", ->
        expect(rbt.peekMinimum()).toBeUndefined()
    rbt2 = new RedBlackTree()
    it "should return the node if there's only one", ->
        rbt2.add 1
        expect(rbt2.peekMinimum()).toBe 1
    it "should return the minimum but does not remove it", ->
        fill(rbt)
        expect(rbt.peekMinimum()).toBe 1
        expect(rbt.peekMinimum()).toBe 1

describe "Peek maximum", ->
    rbt = new RedBlackTree()
    it "should return undefined if the tree's empty", ->
        expect(rbt.peekMaximum()).toBeUndefined()
    rbt2 = new RedBlackTree()
    it "should return the node if there's only one", ->
        rbt2.add 1
        expect(rbt2.peekMinimum()).toBe 1
    it "should return the maximum but does not remove it", ->
        fill(rbt)
        expect(rbt.peekMaximum()).toBe 14
        expect(rbt.peekMaximum()).toBe 14

describe "Remove", ->
    rbt = new RedBlackTree()
    it "should return undefined for deleting in an empty tree", ->
        expect(rbt.remove "hello").toBeUndefined()
        expect(rbt.remove undefined).toBeUndefined()
    it "should return undefined for deleting a non-existent value", ->
        fill(rbt)
        validate rbt, [8, 3, 13, 1, 6, 10, 14, 4, 7]
        expect(rbt.remove "hello").toBeUndefined()
        expect(rbt.remove undefined).toBeUndefined()
        expect(rbt.remove -1).toBeUndefined()
    it "should remove undefined if it's found", ->
        rbt.add undefined
        # has() already checks that undefined is inserted correctly.
        rbt.remove undefined
        expect(rbt.has undefined).toBeFalsy()
    it "should return the removed value", ->
        expect(rbt.remove 8).toBe 8
        expect(rbt.remove 3).toBe 3
        expect(rbt.remove 10).toBe 10
        expect(rbt.remove 1).toBe 1
    it "should have removed correctly", ->
        validate rbt, [13, 4, 14, 6, 7]
    it "should have an undefined root after removing everything", ->
        rbt.remove 14
        rbt.remove 6
        rbt.remove 4
        rbt.remove 7
        rbt.remove 13
        expect(rbt.root).toBeUndefined()

describe "Remove minimum", ->
    rbt = new RedBlackTree()
    it "returns undefined when tree's empty", ->
        expect(rbt.removeMinimum()).toBeUndefined()
    it "returns the smallest value", ->
        fill(rbt)
        expect(rbt.removeMinimum()).toBe 1
        expect(rbt.removeMinimum()).toBe 3
        expect(rbt.removeMinimum()).toBe 4
        expect(rbt.removeMinimum()).toBe 6
        expect(rbt.removeMinimum()).toBe 7
        expect(rbt.removeMinimum()).toBe 8
        expect(rbt.removeMinimum()).toBe 10
        expect(rbt.removeMinimum()).toBe 13
        expect(rbt.removeMinimum()).toBe 14
    it "should return undefined for a newly emptied tree", ->
        expect(rbt.removeMinimum()).toBeUndefined()

describe "Remove maximum", ->
    rbt = new RedBlackTree()
    it "returns undefined when tree's empty", ->
        expect(rbt.removeMinimum()).toBeUndefined()
    it "returns the biggest value", ->
        fill(rbt)
        expect(rbt.removeMaximum()).toBe 14
        expect(rbt.removeMaximum()).toBe 13
        expect(rbt.removeMaximum()).toBe 10
        expect(rbt.removeMaximum()).toBe 8
        expect(rbt.removeMaximum()).toBe 7
        expect(rbt.removeMaximum()).toBe 6
        expect(rbt.removeMaximum()).toBe 4
        expect(rbt.removeMaximum()).toBe 3
        expect(rbt.removeMaximum()).toBe 1
    it "should return undefined for a newly emptied tree", ->
        expect(rbt.removeMinimum()).toBeUndefined()

describe "Randomized tests", ->
    for i in [0..10]
        rbt = new RedBlackTree()
        items = []
        for i in [0...Math.random() * 99]
            item = Math.random() * 9999 - 5000
            items.push item
            rbt.add item
        for item in items
            expect(rbt.remove item).toBe item
            expect(rbt.has item).toBeFalsy()
            expect(rbt.has undefined).toBeFalsy()
        expect(rbt.root).toBeUndefined()










