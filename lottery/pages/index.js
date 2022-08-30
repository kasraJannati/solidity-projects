import styles from '../styles/Home.module.css'
import {ethers} from "ethers"

const onClickConnect = () => {
  if(!window.ethereum) {
    console.log("please install MetaMask")
    return
  }
  const provider = new ethers.providers.Web3Provider(window.ethereum)
  provider.send("eth_requestAccounts", []).then((accounts)=>{
    if(accounts.length>0){
      console.log(accounts)
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
