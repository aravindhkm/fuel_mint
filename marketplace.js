import { Wallet } from "fuels";
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { readFileSync } from 'fs';
import contractAbi from "./native-asset/native-asset-contract/out/debug/native-asset-contract-abi.json" with { type: "json" };
import src20Abi from "../../sway-applications/native-asset/native-asset-contract/out/debug/native-asset-contract-abi.json" with { type: "json" };
import { Contract, ContractFactory, Provider, WalletUnlocked, Address, ReceiptMintCoder, getRandomB256, toBech32 } from 'fuels';
import dotenv from 'dotenv';

// Configure dotenv to load variables from .env file
dotenv.config();

const testnet = "https://testnet.fuel.network/v1/graphql";
const sender = process.env.SENDER_PK;
const receiver = process.env.RECEIVER_PK

let owner_address;
let receiver_address;

let OWNER;
let RECIPIENT;

let market_contract_id = "0x6d2cceef819029abb15731a874dd6c9ac1a402b108478801191dde2685c8586c";
let token_contract_id = "0x698e7726028de5e5c77af768d2e873e2b4b2bac6dbe813cdbecdca24fe4e25ef";

// This is equivalent to __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const getBalance = async () => {
    const owner_balance = await OWNER.getBalance();
    owner_address = (await OWNER.address).bech32Address;
    const receiver_balance = await RECIPIENT.getBalance();
    receiver_address = (await RECIPIENT.address).bech32Address;

    console.log("OWNER balance", owner_address, Number(owner_balance)/1e9);
    console.log("RECIPIENT balance", receiver_address, Number(receiver_balance)/1e9);
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

    const marketInstance = new Contract(market_contract_id, contractAbi, OWNER);
    const tokenInstance = new Contract(token_contract_id, src20Abi, OWNER);


    const total_assets = await tokenInstance.functions.total_assets().simulate();
    console.log("total_assets ---------------->", Number(total_assets.value));

    const zeroX = "0x";
    let subId = Number(5)
    const fill0 = subId.toString().padStart(64, "0")
    const stringSubId = fill0.padStart(66, zeroX);
    const assetId = ReceiptMintCoder.getAssetId(token_contract_id, stringSubId);

    console.log("assetId          ---------------->", assetId);

    const recipientAddress = new Address(receiver_address);
    const recipientIdentity = { Address: { bits: recipientAddress.toHexString() } };
    const owner_address_addr_npm = new Address(owner_address);
    const ownerAddress = { Address: { bits: owner_address_addr_npm.toHexString() } };

    // console.log('receiver_address   ----------------->', receiver_address);
    // console.log('market_contract_id ----------------->', market_contract_id, toBech32(market_contract_id));

    // token init
    // let initialize_owner_tx = await marketInstance.functions.constructor(ownerAddress).call();
    // let ownership = await initialize_owner_tx.waitForResult();
    // console.log("Ownership transactionId:", ownership.transactionId);
    // token mint
    // const {transactionId} = await tokenInstance.functions.mint(recipientIdentity,stringSubId, 0.1e9).call();
    // console.log("transactionResult", transactionId); 

    const _asset = { bits: assetId };
    const total_supply = await tokenInstance.functions.total_supply(_asset).simulate();
    console.log("total_supply --------------->", Number(total_supply.value)/ 1e9);


    const src20_balance_before = await RECIPIENT.getBalance(assetId);
    console.log("src20_balance_before", Number(src20_balance_before) / 1e9);

    // const tx_data = await RECIPIENT.transfer(toBech32(market_contract_id), 2000000, assetId)
    // console.log("tx", tx_data.id);

    const src20_balance_after = await RECIPIENT.getBalance(assetId);
    console.log("src20_balance_after", Number(src20_balance_after));


    // marketplace init
    // let initialize_owner_tx = await marketInstance.functions.constructor(ownerAddress,ownerAddress,_asset).call();
    // let ownership = await initialize_owner_tx.waitForResult();
    // console.log("Ownership transactionId:", ownership.transactionId);





    // const tx = await OWNER.transfer(toBech32(market_contract_id), 200000,BaseAssetId)
    // console.log("tx", tx.id);

    const contract_wallet = Wallet.fromAddress(toBech32(market_contract_id), provider);
    const contract_token_balance = await contract_wallet.getBalance(assetId)
    console.log("contract_token_balance", Number(contract_token_balance) / 1e9);

    const contract_token_all_balance = await contract_wallet.getBalances()
    console.log("contract_token_all_balance", contract_token_all_balance);

    // let claim_tx = await marketInstance.functions.claim(100000, recipientIdentity).call();
    // let claim_tx_result = await claim_tx.waitForResult();
    // console.log("claim_tx_result transactionId:", claim_tx_result.transactionId);

    let asset_id_from_contract = await marketInstance.functions.get_asset_id().simulate()
    console.log("asset_id_from_contract  -------------->", asset_id_from_contract.value);



    let get_asset_balance = await marketInstance.functions.get_asset_balance().simulate()
    console.log("get_asset_balance  -------------->", Number(get_asset_balance.value));


    let _stringSubId = { bits: "0xd331425f990cafd224fec452061b26257fed4fe0d56f91b3fd0db1623ae61146"}
    let get_asset_balance_by_id = await marketInstance.functions.get_asset_balance_two(_stringSubId).simulate()
    console.log("get_asset_balance_by_id  -------------->", Number(get_asset_balance_by_id.value));

    let _BaseAssetId = {bits : BaseAssetId};
    let get_asset_balance_by_id_native = await marketInstance.functions.get_asset_balance_two(_BaseAssetId).simulate()
    console.log("get_asset_balance_by_id_native  -------------->", Number(get_asset_balance_by_id_native.value));


    let get_asset_balance_all = await marketInstance.functions.get_asset_balance_all().simulate()
    console.log("get_asset_balance_by_id_native  -------------->", Number(get_asset_balance_all.value));

}

main()
    .then((res) => { return res })
    .catch((err) => console.log(err));


