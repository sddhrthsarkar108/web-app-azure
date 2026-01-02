import { useMsal } from "@azure/msal-react";
import { loginRequest } from "../authConfig";
import { lazy, Suspense } from 'react';

// Lazy load the heavy grid component
const EnterpriseGrid = lazy(() => import('../components/EnterpriseGrid'));

function Home() {
    const { instance, accounts } = useMsal();
    const account = accounts[0];

    // Placeholder skeleton while grid loads
    const GridSkeleton = () => (
        <div className="flex flex-col gap-4 h-[650px] w-full animate-pulse">
            <div className="bg-gray-200 p-4 rounded-lg h-16 w-full"></div>
            <div className="flex-1 bg-gray-200 rounded-lg w-full"></div>
            <div className="bg-gray-200 p-2 rounded-lg h-10 w-full"></div>
        </div>
    );

    const handleLogin = () => {
        instance.loginPopup(loginRequest).catch(e => {
            console.error(e);
        });
    }

    return (
        <div className="min-h-screen bg-gray-50 p-8">
            <div className="max-w-7xl mx-auto space-y-8">
                <header className="flex justify-between items-center bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                    <div>
                        <h1 className="text-3xl font-bold text-gray-900 tracking-tight">Dashboard</h1>
                        <p className="text-gray-500 mt-1">Welcome to the enterprise portal</p>
                    </div>
                    <div>
                        {account ? (
                            <div className="flex items-center gap-3 bg-blue-50 px-4 py-2 rounded-lg text-blue-700 font-medium">
                                <span className="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></span>
                                {account.name}
                            </div>
                        ) : (
                            <button
                                onClick={handleLogin}
                                className="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-6 rounded-lg transition-colors shadow-sm focus:ring-4 focus:ring-blue-100"
                            >
                                Sign In
                            </button>
                        )}
                    </div>
                </header>

                <main>
                    <Suspense fallback={<GridSkeleton />}>
                        <EnterpriseGrid />
                    </Suspense>
                </main>
            </div>
        </div>
    );
}

export default Home;
