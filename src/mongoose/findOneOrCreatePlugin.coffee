module.exports = ()->

  return (schema)->

    schema.statics.findOneOrCreate = (condition, doc, callback)->

      @findOne condition, (err, result)=>

        if result
          callback(err, result)
        else
          @create(doc, callback)
