module.exports = (SpurErrors)->

  return (schema)->

    schema.statics.strictFindOne = (condition, callback)->

      @findOne condition, (err,result)->

        if result
          callback(err, result)
        else
          callback SpurErrors.NotFoundError.create()
