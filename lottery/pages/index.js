import styles from '../styles/Home.module.css'
import {ethers} from "ethers"


import Lottery from "../artifacts/contracts/Lottery.sol/Lottery.json";
// async connectToMetamask() {
//   const provider = new ethers.providers.Web3Provider(window.ethereum)
//   const accounts = await provider.send("eth_requestAccounts", []);
//   const balance = await provider.getBalance(accounts[0]);
//   const balanceInEther = ethers.utils.formatEther(balance);
//   const block = await provider.getBlockNumber();
//   provider.on("block", (block) => {
//     this.setState({ block })
//   })
//   this.setState({ selectedAddress: accounts[0], balance: balanceInEther, block })
// }
const onClickConnect = () => {
  if(!window.ethereum) {
    console.log("please install MetaMask")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
 
  provider.send("eth_requestAccounts", []).then((accounts)=>{
    if(accounts.length>0){
      console.log(accounts[0])
      provider.getBalance(accounts[0]).then((balance) => {
        const balanceInEth = ethers.utils.formatEther(balance)   // convert a currency unit from wei to ether
        console.log(`balance: ${balanceInEth} ETH`)

        
  const daiContract = new ethers.Contract('0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199', Lottery, provider);
  const tokenName =  daiContract.balance();
  console.log(daiContract)

      })
    }
  })
  .catch((e)=>console.log(e))





}


export default function Home() {


  
  return (
    <div className={styles.container}>
      <button type="button" onClick={onClickConnect}>Login to Metamask</button>
    </div>
  )
}
