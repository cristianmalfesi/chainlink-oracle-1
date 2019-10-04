require('dotenv').config()
const MyConsumer = artifacts.require('MyConsumer')

module.exports = (deployer, network) => {
  deployer.deploy(MyConsumer, process.env.ORACLE, process.env.JOB_ID)
}
