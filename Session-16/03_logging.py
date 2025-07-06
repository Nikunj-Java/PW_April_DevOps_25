import logging

logging.basicConfig(
    filename='system.log',
    level=logging.DEBUG,
    format='%(asctime)s-%(levelname)s-%(message)s'
)

#log messages
logging.info("System Initialized")
logging.info("User Login Successful")
logging.error("Running out of memory")
logging.warning("High Memory Usage")
logging.error("Unable to connect to MySQL Database")