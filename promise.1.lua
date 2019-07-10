local Promise = {}

Promise.create = function(future)
  local promise = {}
  local done_callback = nil
  local fail_callback = nil
  local done_callback_data = nil
  local fail_callback_data = nil

  function resolve(data)
    if done_callback then
      done_callback(data)
    end
    done_callback_data = data
  end

  function reject(error)
    if fail_callback then
      fail_callback(error)
    end
    fail_callback_data = error
  end

  promise.done = function(callback)
    if done_callback_data then
      callback(done_callback_data)
    end
    done_callback = callback
  end
  promise.fail = function(callback)
    if fail_callback_data then
      callback(fail_callback_data)
    end
    fail_callback = callback
  end

  future(resolve, reject)

  return promise
end

return Promise

-- local promise = Promise.create(function(resolve, reject)
--   if jaja then resolve(kaka) else reject(err)end
-- end)
