-- Tensorboard

require 'torch'
local crayon = require 'crayon'
require 'server'
require 'client'
require 'os'
local c = require 'ansicolors'


-- dataloader
local TensorBoard = torch.class('TensorBoard')


--[[
function TensorBoard.new()
    --assert(type(opt)=='table')
    --local self = {}
    --for k,v in pairs(TensorBaord) do self[k] = v end
    --for k,v in pairs(opt) do self[k] = v end
    local self = {}
end
]]--

function TensorBoard:__init()
    return -1
end


function TensorBoard:env_setup()
    print(c('%{green}>>> Installing crayon luarocks module....'))
    os.execute('luarocks install crayon')
    print(c('%{green}>>> Downloading tf docker image file....'))
    os.execute('docker pull alband/crayon')
end


function TensorBoard:create_server(port)
    print(port)
    assert(type(port)=='number')
    
    os.execute('docker rm -f crayon')           -- make sure no container with same name.
    --local cmd = string.format('docker run -d -p %d:%d -p %d:%d --name crayon alband/crayon', port, port+100,port+1, port+101)
    local cmd = string.format('docker run -d -p %d:%d -p %d:%d --name crayon alband/crayon', port, 8888, port+1, 8889)
    os.execute(cmd)
end


function TensorBoard:destroy_server(port) 
    os.execute('docker rm -f crayon')
end


function TensorBoard:create_client(port)

    local cmd = "ifconfig eth0 | grep " .. 
                "'inet addr" ..  
                "' | cut -d " .. "':" .. "' -f 2 | cut -d " .. "' " .. 
                "' -f 1"
    local handle = io.popen(cmd)
    local ip_address = handle:read("*a")
    handle:close()

    self.client = crayon.CrayonClient(ip_address, port+1)
end









return TensorBoard

