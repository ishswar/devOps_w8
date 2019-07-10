# FrontEnd.py

from nameko.standalone.rpc import ClusterRpcProxy
from nameko.web.handlers import http
import os

config = {
   # print("IP is"+ self.config.get('IP'))
    'AMQP_URI': "amqp://guest:guest@"+os.environ['BACKEND_IP']+":7600//"  # e.g. "pyamqp://guest:guest@localhost"
}

#n.rpc.greeting_service.hello

class HttpService:
	name = "http_service"

	@http('GET', '/get/<string:value>')
	def get_method(self, request, value):
		print("Input is "+ value)
		with ClusterRpcProxy(config) as cluster_rpc:
			rest = cluster_rpc.backEnd_service.getFileContents(value)
			print("File Content of file testfile1.text: \n###############################################\n"+ rest + "\n####################################################")
			if rest.startswith( '~' ):
			 return 404, "File "+ value + " NOT_FOUND"
			else:
			 return rest
