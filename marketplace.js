import { Wallet } from "fuels";
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { readFileSync } from 'fs';
import contractAbi from "./native-asset/native-asset-contract/out/debug/native-asset-contract-abi.json" with { type: "json" };
import src20Abi from "../../sway-applications/native-asset/native-asset-contract/out/debug/native-asset-contract-abi.json" with { type: "json" };
import { Contract, ContractFactory, Provider, WalletUnlocked, Address, ReceiptMintCoder , getRandomB256} from 'fuels';

const testnet = "https://testnet.fuel.network/v1/graphql";
const sender = "0x5461173083b3c83db02693f9671fb55b993243e4dfd2183d0776a1ff2c2b63b8"; // account 1
const receiver = "0xd30c19d79f4c6f8fbdebe0f04b6385aede6f6ef639df48d5ddd910265983284a" // account 2

let owner_address;
let receiver_address;

let OWNER;
let RECIPIENT;

let market_contract_id = "0xbeee6fb2e32e88015c7e03c9d41a537ecf384b7b6d33401db0e6b1741dcb9b8e";
let token_contract_id = "0x698e7726028de5e5c77af768d2e873e2b4b2bac6dbe813cdbecdca24fe4e25ef";

// This is equivalent to __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const getBalance = async () => {
    const owner_balance = await OWNER.getBalance();
    owner_address = (await OWNER.address).bech32Address;
    const receiver_balance = await RECIPIENT.getBalance();
    receiver_address = (await RECIPIENT.address).bech32Address;    

    // console.log("OWNER balance", owner_address, Number(owner_balance));
    // console.log("RECIPIENT balance", receiver_address, Number(receiver_balance));
}


const main = async () => {
    const provider = await Provider.create(testnet)
    const BaseAssetId = provider.getBaseAssetId();

    OWNER = new WalletUnlocked(sender, provider);
    RECIPIENT = new WalletUnlocked(receiver, provider);

    if (!sender) {
        console.error("Private key is required")
        return
    }

    // console.log("BaseAssetId", BaseAssetId);
    await getBalance();
    
    const contractInstance = new Contract(market_contract_id, contractAbi, OWNER);
    const tokenIstance = new Contract(token_contract_id, src20Abi, OWNER);

    
    const total_assets = await tokenIstance.functions.total_assets().simulate();
    console.log("total_assets ---------------->", Number(total_assets.value));
    
    // const zeroX = "0x";
    // let subId = Number(4)
    // const fill0 = subId.toString().padStart(64, "0")
    // const stringSubId = fill0.padStart(66, zeroX);
    // console.log("stringSubId", stringSubId);

    // const recipientAddress = new Address(receiver_address);
    // const recipientIdentity = { Address: { bits: recipientAddress.toHexString() }};
    // console.log("recipientIdentity",  recipientAddress.toHexString(),receiver_address );
    
    // const owner_address_addr_npm = new Address(owner_address);
    // const ownerAddress = {
    //     Address: {
    //       bits: owner_address_addr_npm.toHexString()
    //     }
    //   };

    // let initialize_owner_tx = await contractInstance.functions.constructor(ownerAddress).call();
    // let ownership = await initialize_owner_tx.waitForResult();
    // console.log("Ownership transactionId:", ownership.transactionId);

    // const {transactionId} = await contractInstance.functions.mint(recipientIdentity,stringSubId, 1e7).call();
    // console.log("transactionResult", transactionId);  


    // const assetId = ReceiptMintCoder.getAssetId(market_contract_id, stringSubId);
    // console.log("assetId", assetId);
    
    // const src20_balance_before = await RECIPIENT.getBalance(assetId);
    // console.log("src20_balance_before", Number(src20_balance_before));

    // const tx = await RECIPIENT.transfer(owner_address, 1e5,assetId)
    // console.log("tx", tx.id);

    // const src20_balance_after = await RECIPIENT.getBalance(assetId);
    // console.log("src20_balance_after", Number(src20_balance_after));

    // const tx = await OWNER.transfer(receiver_address, 0.1e9,BaseAssetId)
    // console.log("tx", tx.id);

}

main()
    .then((res) => { return res })
    .catch((err) => console.log(err));


