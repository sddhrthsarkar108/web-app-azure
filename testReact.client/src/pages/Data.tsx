import { useEffect, useState } from "react";
import axios, { AxiosError } from "axios";
import { useMsal } from "@azure/msal-react";
import { loginRequest } from "../authConfig";

interface WeatherForecast {
    date: string;
    temperatureC: number;
    temperatureF: number;
    summary: string;
}

function Data() {
    const { instance, accounts } = useMsal();
    const account = accounts[0];
    const [items, setItems] = useState<WeatherForecast[]>([]);
    const [error, setError] = useState("");

    useEffect(() => {
        const fetchData = async () => {
            if (!account) return;
            try {
                const response = await instance.acquireTokenSilent({
                    ...loginRequest,
                    account: account
                });

                const result = await axios.get<WeatherForecast[]>("/weatherforecast", {
                    headers: {
                        Authorization: `Bearer ${response.accessToken}`
                    }
                });
                setItems(result.data);
            } catch (e: any) {
                if (e instanceof AxiosError) {
                    setError(`Response: ${e.response?.status}: ${e.response?.statusText}`);
                } else {
                    setError(String(e));
                }
            }
        };
        fetchData();
    }, [account, instance]);

    if (error) {
        return <div>Error: {error}</div>;
    }

    return (
        <table className="table w-full">
            <thead className="font-bold border-b border-gray-500">
                <tr>
                    <td>Date</td>
                    <td>Temp</td>
                    <td>Comment</td>
                </tr>
            </thead>
            <tbody>
                {items.map((f, i) => (
                    <tr key={i}>
                        <td>{f.date}</td>
                        <td>{f.temperatureF}F/{f.temperatureC}C</td>
                        <td>{f.summary}</td>
                    </tr>
                ))}
            </tbody>
        </table>
    );
}
export default Data;
