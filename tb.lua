-- Tensorboard

require 'torch'
local crayon = require 'crayon'
require 'server'
require 'client'
require 'os'
local c = require 'ansicolors'
local threads = require 'threads'

-- dataloader
local TensorBoard = torch.class('TensorBoard')


function TensorBoard:__init(flag)
    local flag = flag or false
    if flag then self:env_setup() end
    self.exp = nil
    self.record = {}
    
    --self.t = threads.Threads(2)
    --self.t:specific(true)           -- switch to specific mode.
end


function TensorBoard:env_setup()
    print(c('%{green}>>> Installing crayon luarocks module....'))
    os.execute('luarocks install crayon')
    print(c('%{green}>>> Downloading tf docker image file....'))
    os.execute('docker pull alband/crayon')
end


function TensorBoard:create_server(port)
    assert(type(port)=='number')
   
   --[[
    function server(port)
        os.execute('docker rm -f crayon')           -- make sure no container with same name.
        print(port)
        local cmd = string.format('docker run -d -p %d:%d -p %d:%d --name crayon alband/crayon &', port, 8888, port+1, 8889)
        os.execute(cmd)
    end
    self.t:addjob(2, function(c) return c end, server, port)                -- allocate thread id 2 to server.
    --self.t:addjob(2, server)                -- allocate thread id 2 to server.
    self.t:dojob()
    ]]--
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
    local ip_address = handle:read("*a"):gsub('%s+', "")
    handle:close()

    self.client = crayon.CrayonClient(ip_address, port+1)
end



-- summary function like tf.
function TensorBoard:create_exp(name)
    assert(type(name)=='string')

    --self.client:remove_all_experiments()            --refresh.
    self.exp = self.client:open_experiment(name)
end
function TensorBoard:remove_exp(name)
    assert(type(name)=='string')
    return self.client:remove_experiment(name)
end
function TensorBoard:summary_scalar(name, value, step)
    --assert(self.exp~=nil, 'create experiment first. (use "create_exp() func.")')
    if self.record[name] == nil then self.record[name]={data={}, step={}, type='scalar'} end
    table.insert(self.record[name].data, value)
    table.insert(self.record[name].step, step)
end
function TensorBoard:summary_histogram()
    print('tt')
end
function TensorBoard:summary_merge_all()
    print('d')
end
function TensorBoard:summary_FileWriter()
    print('ss')
end
function TensorBoard:summary_update(target)
    local target = target or 'all'

    for k, v in pairs(self.record) do
        local cur = self.record[k]
        if cur.type == 'scalar' then
            for idx = 1, #cur.step do self.exp:add_scalar_value(k, cur.data[idx], nil, cur.step[idx]) end
        end
        
    end
end
function TensorBoard:summary_flush()
    self.record = {}
end







return TensorBoard

