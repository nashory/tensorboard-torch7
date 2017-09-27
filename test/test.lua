-- module test.

require 'sys'
require 'os'
package.path = package.path .. ';../?.lua'
require 'tb'



-- server test.
--tb.env_setup()

local tb = TensorBoard()

local port = 7998
--tb:create_server(port)
tb:create_client(port)




