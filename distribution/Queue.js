/*
Properties:

- size: The total number of items.
*/


(function() {
  var Queue;

  Queue = (function() {
    function Queue(initialArray) {
      if (initialArray == null) {
        initialArray = [];
      }
      /*
      Pass an optional array to be transformed into a queue. The item at index 0
      is the first to be dequeued.
      */

      this._content = initialArray;
      this._dequeueIndex = 0;
      this.size = this._content.length;
    }

    Queue.prototype.enqueue = function(item) {
      /*
      _Returns:_ the item.
      */
      this.size++;
      this._content.push(item);
      return item;
    };

    Queue.prototype.dequeue = function() {
      /*
      _Returns:_ the dequeued item.
      */

      var itemToDequeue;

      if (this.size === 0) {
        return;
      }
      this.size--;
      itemToDequeue = this._content[this._dequeueIndex];
      this._dequeueIndex++;
      if (this._dequeueIndex * 2 > this._content.length) {
        this._content = this._content.slice(this._dequeueIndex);
        this._dequeueIndex = 0;
      }
      return itemToDequeue;
    };

    Queue.prototype.peek = function() {
      /*
      Check the next item to be dequeued, without removing it.
      
      _Returns:_ the item.
      */
      return this._content[this._dequeueIndex];
    };

    return Queue;

  })();

  module.exports = Queue;

}).call(this);
