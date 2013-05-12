###
Doubly Linked.

Properties:

- head: first item.
- tail: last item.
- size: total number of items.
- item.value: value passed to the item when calling `add()`.

Traverse through the nodes with `prev` and `next`. Get the value using `value`.
```coffee
list = new LinkedList()
list.add 1
list.add 4
list.add 7
list.head.next.value # 4.
```
###
class LinkedList
    constructor: (valuesToAdd = []) ->
        ###
        Can pass an array of elements to link together during `new LinkedList()`
        initiation.
        ###
        @head =
            prev: undefined
            value: undefined
            next: undefined
        @tail =
            prev: undefined
            value: undefined
            next: undefined
        # We keep track of the size for operations such as detecting empty
        # linked list and determining whether to start at the head or the tail
        # when getting a node.
        @size = 0
        @add value for value in valuesToAdd

    get: (position) ->
        ###
        Get the item at `position` (optional). Accepts negative index:
        ```coffee
        myList.get(-1) # Returns the last element.
        ```
        However, passing a negative index that surpasses the boundary will
        return undefined:
        ```coffee
        myList = new LinkedList([2, 6, 8, 3])
        myList.get(-5) # Undefined.
        myList.get(-4) # 2.
        ```
        _Returns:_ item gotten, or undefined if not found.
        ###
        if not (-@size <= position < @size) then return

        position = @_adjust position
        # Starting from the head or tail will require a different loop count.
        # How many times to loop in each case?
        if position * 2 < @size
            currentNode = @head
            currentNode = currentNode.next for i in [1..position] by 1
        else
            currentNode = @tail
            currentNode = currentNode.prev for i in [1..@size - position - 1] by 1
        return currentNode

    # There's a trade-off between conciseness and developer comfort when
    # choosing between an add and remove that do all, and array-like methods
    # such as pop and shift. We choose the former. Wrapper methods are a
    # possibility.
    add: (value, position = @size) ->
        ###
        Add a new item at `position` (optional). Defaults to adding at the end.
        `position`, just like in `get()`, can be negative (within the negative
        boundary). Position specifies the place the value's going to be, and the
        old node will be pushed higher. `add(-2)` on list of size 7 is the
        same as `add(5)`.

        _Returns:_ item added.
        ###
        if not (-@size <= position <= @size) then return
        nodeToAdd = {value: value}
        position = @_adjust position
        if @size is 0
            @head = nodeToAdd
        else
            if position is 0
                [@head.prev, nodeToAdd.next, @head] = [nodeToAdd, @head, nodeToAdd]
            else
                # Get the node before the position we're inserting. Its next
                # needs to be changed.
                currentNode = @get(position - 1)
                [nodeToAdd.next, currentNode.next?.prev, currentNode.next, nodeToAdd.prev] =
                [currentNode.next, nodeToAdd, nodeToAdd,currentNode]
        # Join the tail too. Modify tail when the node was inserted at the last
        # position.
        if position is @size then @tail = nodeToAdd
        @size++
        return value

    remove: (position = @size - 1) ->
        ###
        Remove an item at index `position` (optional). Defaults to the last
        item. Index can be negative (within the boundary).

        _Returns:_ item removed.
        ###
        # Remove requires different position limits than add.
        if not (-@size <= position < @size) then return
        if @size is 0 then return

        position = @_adjust position
        if @size is 1
            valueToReturn = @head.value
            @head.value = @tail.value = undefined
        else
            if position is 0
                valueToReturn = @head.value
                @head = @head.next
                @head.prev = undefined
            else
                currentNode = @get(position)
                valueToReturn = currentNode.value
                currentNode.prev.next = currentNode.next
                currentNode.next?.prev = currentNode.prev
                # Notice how this conditional's placement differs from add. Tail
                # is taken care of in this case.
                if position is @size - 1 then @tail = currentNode.prev
        @size--
        return valueToReturn

    # We need to be careful about finding undefined and null values. The
    # starting position accepts negative indexing.
    indexOf: (value, startingPosition = 0) ->
        ###
        Find the index of an item, similarly to `array.indexOf()`. Defaults to
        start searching from the beginning, by can start at another position by
        passing `startingPosition`. This parameter can also be negative; but
        unlike the other methods of this class, `startingPosition` (optional)
        can be as small as desired; a value of -999 for a list of size 5 will
        start searching normally, at the beginning.

        **Note:** searches forwardly, **not** backwardly, i.e:
        ```coffee
        myList = new LinkedList([2, 3, 1, 4, 3, 5])
        myList.indexOf(3, -3) # Returns 4, not 1
        ```
        _Returns:_ index of item found, or -1 if not found.
        ###
        if (not @head.value? and not @head.next) or startingPosition >= @size
            return -1
        startingPosition = Math.max(0, @_adjust startingPosition)
        currentNode = @get startingPosition
        position = startingPosition
        while currentNode
            if currentNode.value is value then break
            currentNode = currentNode.next
            position++
        return if position is @size then -1 else position

    # Position allows negative index for python style quick access to last
    # items. Position smaller than -size or bigger than size is discarded,
    # as they're more likely done by mistakes.
    _adjust: (position) ->
        if position < 0 then @size + position
        else position

module.exports = LinkedList
