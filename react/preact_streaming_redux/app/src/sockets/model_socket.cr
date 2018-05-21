struct ModelSocket < Maze::WebSockets::ClientSocket
  channel "model", ModelChannel

  def on_connect
    # do some authentication here
    # return true or false, if false the socket will be closed
    true
  end

  def self.send_model(topic : String, action : String, json_model : String)
    self.broadcast("message", topic, action, {"data" => json_model} )
  rescue ex
    puts "Error broadcasting model #{ex.message}"
  end

end

module Sockets::Model

  def self.json_encode_field(json, col, value)
    case value
    when Bytes
      # custom json encoding. Avoid extra allocations.
      json.field col do
        json.array do
          value.each do |e|
            json.scalar e
          end
        end
      end
    else
      # encode the value as their built in json format.
      json.field col do
        value.to_json(json)
      end
    end
  end

  def self.send_model(model_name : String, action : String, json_model : String)
    ModelSocket.send_model(model_name, action, json_model)
  end

  def self.send_model(model_name : String, action : String, hash_model : Hash(String,DB::Any))
    # JSON encode and handle Bytes (Slice(Uint8))
    io = IO::Memory.new(4096_i64)

    JSON.build(io) do |json|
      json.object do
        hash_model.each do |k, v|
          json_encode_field json, k, v
        end
      end
    end

    ModelSocket.send_model(model_name, action, io.to_s)
  end
end
