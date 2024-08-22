import { Wallet } from "fuels";
import { Contract, ContractFactory, Provider, WalletUnlocked } from 'fuels';
import dotenv from 'dotenv';

// Configure dotenv to load variables from .env file
dotenv.config();

const testnet = "https://testnet.fuel.network/v1/graphql";
const privateKey = process.env.OTHER_PK;
const receiver = process.env.RECEIVER_PK;

let owner_address;
let receiver_address;

let OWNER;
let RECIPIENT;

const getBalance = async() => {
    const owner_balance = await OWNER.getBalance();
    owner_address = (await OWNER.address).bech32Address;
    const receiver_balance = await RECIPIENT.getBalance();
    receiver_address = (await RECIPIENT.address).bech32Address;

    console.log("OWNER balance", owner_address, Number(owner_balance) );
    // console.log("OWNER address", owner_address);
    console.log("RECIPIENT balance", receiver_address ,Number(receiver_balance) );
    // console.log("RECIPIENT address", receiver_address);
}

const main = async (_provider) => {
    const provider = await Provider.create(_provider)
    const BaseAssetId = provider.getBaseAssetId();

    OWNER = new WalletUnlocked(privateKey, provider);
    RECIPIENT = new WalletUnlocked(receiver, provider);

    if (!privateKey) {
        console.error("Private key is required")
        return
    }
    
    console.log("BaseAssetId", BaseAssetId);
    
    await getBalance();
    // const tx = await OWNER.transfer(receiver_address, 1e9,BaseAssetId)
    // console.log("tx", tx.id);
    
    await getBalance();

}

main(testnet)
    .then((res) => { return res })
    .catch((err) => console.log(err));