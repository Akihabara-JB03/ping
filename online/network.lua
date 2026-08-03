-- network.lua (Luaの Socket.io プラグインを使うノリ)
local socketio = require("socketio")
local client = socketio.connect("無料のテストサーバーのURL")

-- 💡 1. C言語から「部屋番号（0000など）」を受け取ってくじを引く
function init_network_room(room_id)
    client:emit("join_room", room_id)
end

-- 💡 2. 毎フレーム、C言語から自分のY座標を貰って送り、相手のを返す
function sync_paddle_position(my_y)
    -- 自分のY座標を部屋の相手に飛ばす
    client:emit("paddle_move", my_y)
    
    -- 相手から届いた最新の数字をC言語に送り返す
    return enemy_paddle_y
end

-- 相手からデータが届いた時に動くイベント
client:on("paddle_move", function(data)
    enemy_paddle_y = tonumber(data)
end)
