import { Wallet } from "fuels";
import countabi from "../counter-contract/out/debug/counter-contract-abi.json" with { type: "json" };
import { Contract, ContractFactory, Provider, WalletUnlocked } from 'fuels';

const testnet = "https://testnet.fuel.network/v1/graphql";
const sender = "0xde97d8624a438121b86a1956544bd72ed68cd69f2c99555b08b1e8c51ffd511c";
const receiver = "0x5461173083b3c83db02693f9671fb55b993243e4dfd2183d0776a1ff2c2b63b8" // mahes

let owner_address;
let receiver_address;

let OWNER;
let RECIPIENT;

let contract_id = "0x74c64386165a384c16b1b09246d322eeae3d45229937bb0d5adb38863a170af0";

const getBalance = async () => {
    const owner_balance = await OWNER.getBalance();
    owner_address = (await OWNER.address).bech32Address;
    const receiver_balance = await RECIPIENT.getBalance();
    receiver_address = (await RECIPIENT.address).bech32Address;

    console.log("OWNER balance", owner_address, Number(owner_balance));
    console.log("RECIPIENT balance", receiver_address, Number(receiver_balance));
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

    const contractInstance = new Contract(contract_id, countabi, OWNER);
    const {transactionId} = await contractInstance.functions.increment_counter().call();
    console.log("transactionResult", transactionId);
    
    const {value} = await contractInstance.functions.get_count().simulate();
    console.log("return value", value);
    

}

main()
    .then((res) => { return res })
    .catch((err) => console.log(err));