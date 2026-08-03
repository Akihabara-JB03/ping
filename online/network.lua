-- network.lua
local socketio = require("socketio")

-- 公式デモ用のSocket.ioサーバー
local client = socketio.connect("https://socketio-chat-h948.onrender.com")

function init_network_room(room_id)
    -- 他人と混ざらないように、部屋名を長めのユニークな文字列にする
    client:emit("join_room", "pingpong_game_room_secret_" .. room_id)
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
