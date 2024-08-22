import { Wallet } from "fuels";
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { readFileSync } from 'fs';
import src20Abi from "../../sway-applications/native-asset/native-asset-contract/out/debug/native-asset-contract-abi.json" with { type: "json" };
import { Contract, ContractFactory, Provider, WalletUnlocked, Address, ReceiptMintCoder , getRandomB256} from 'fuels';
import dotenv from 'dotenv';

// Configure dotenv to load variables from .env file
dotenv.config();

const testnet = "https://testnet.fuel.network/v1/graphql";
const sender = process.env.SENDER_PK;
const receiver = process.env.RECEIVER_PK;

let owner_address;
let receiver_address;

let OWNER;
let RECIPIENT;

let contract_id = "0x698e7726028de5e5c77af768d2e873e2b4b2bac6dbe813cdbecdca24fe4e25ef";
// let contract_id = "0xa4bd3de9d487269cbca310f3723f335d0b8c3aebed63c43882b5c677384bfc57"; // SRC20

// This is equivalent to __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const getBalance = async () => {
    const owner_balance = await OWNER.getBalance();
    owner_address = (await OWNER.address).bech32Address;
    const receiver_balance = await RECIPIENT.getBalance();
    receiver_address = (await RECIPIENT.address).bech32Address;    

    console.log("OWNER balance", owner_address, Number(owner_balance));
    console.log("RECIPIENT balance", receiver_address, Number(receiver_balance));
}

const deploy = async() => {
    const exchangeBytecode = readFileSync(join(__dirname, '../../sway-applications/native-asset/native-asset-contract/out/debug/native-asset-contract.bin'));
    const exchangeFactory = new ContractFactory(exchangeBytecode, src20Abi, OWNER);
    let exchange = await exchangeFactory.deployContract({OWNER});
    console.log("Exchange contract id:", exchange)
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

    console.log("BaseAssetId", BaseAssetId);
    await getBalance();
    
    const contractInstance = new Contract(contract_id, src20Abi, OWNER);

    
    const {value} = await contractInstance.functions.total_assets().simulate();
    console.log("return value", value);
    
    const zeroX = "0x";
    let subId = Number(4)
    const fill0 = subId.toString().padStart(64, "0")
    const stringSubId = fill0.padStart(66, zeroX);
    console.log("stringSubId", stringSubId);

    let getRandomB256_local = getRandomB256()

    const recipientAddress = new Address(receiver_address);
    const recipientIdentity = { Address: { bits: recipientAddress.toHexString() }};
    console.log("recipientIdentity",  recipientAddress.toHexString(),receiver_address );
    
    const owner_address_addr_npm = new Address(owner_address);
    const ownerAddress = {
        Address: {
          bits: owner_address_addr_npm.toHexString()
        }
      };

    // let initialize_owner_tx = await contractInstance.functions.constructor(ownerAddress).call();
    // let ownership = await initialize_owner_tx.waitForResult();
    // console.log("Ownership transactionId:", ownership.transactionId);

    // const {transactionId} = await contractInstance.functions.mint(recipientIdentity,stringSubId, 1e7).call();
    // console.log("transactionResult", transactionId);  


    const assetId = ReceiptMintCoder.getAssetId(contract_id, stringSubId);
    console.log("assetId", assetId);
    
    const src20_balance_before = await RECIPIENT.getBalance(assetId);
    console.log("src20_balance_before", Number(src20_balance_before));

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



// "inputs": [
//         {
//           "name": "recipient",
//           "type": 5,
//           "typeArguments": null
//         },
//         {
//           "name": "sub_id",
//           "type": 1,
//           "typeArguments": null
//         },
//         {
//           "name": "amount",
//           "type": 20,
//           "typeArguments": null
//         }
//       ],