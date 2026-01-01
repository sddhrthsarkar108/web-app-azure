import { useMsal } from "@azure/msal-react";
import { loginRequest } from "../authConfig";

function Home() {
    const { instance, accounts } = useMsal();
    const account = accounts[0];

    const handleLogin = () => {
        instance.loginPopup(loginRequest).catch(e => {
            console.error(e);
        });
    }

    return (
        <div>
            <p>
                {account ? <div>{account.name}</div> : <button onClick={handleLogin} className="btn">Click here to login</button>}
            </p>
        </div>
    );
}
export default Home;
