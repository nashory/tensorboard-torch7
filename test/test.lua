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


tb:create_exp('nashory')
tb:summary_scalar('accu', 25, 1)
tb:summary_scalar('accu', 27, 2)
tb:summary_scalar('accu', 32, 3)
tb:summary_scalar('accu', 37, 4)

tb:summary_update()

