import { useState, useMemo, useEffect, useCallback, useRef } from 'react';
import { AgGridReact } from 'ag-grid-react';
import {
    themeQuartz,
    type ColDef,
    type RowClassRules,
    type RowSelectionOptions
} from 'ag-grid-community';
import {
    ModuleRegistry,
    ClientSideRowModelModule,
    ValidationModule,
    PaginationModule,
    TextFilterModule,
    NumberFilterModule,
    DateFilterModule,
    CellStyleModule,
    RowSelectionModule,
    CsvExportModule,
    QuickFilterModule,
    RowStyleModule,
} from 'ag-grid-community';

// Register modules
ModuleRegistry.registerModules([
    ClientSideRowModelModule,
    ValidationModule,
    PaginationModule,
    TextFilterModule,
    NumberFilterModule,
    DateFilterModule,
    CellStyleModule,
    RowSelectionModule,
    CsvExportModule,
    QuickFilterModule,
    RowStyleModule
]);

// Note: CSS imports removed to solve Theming API conflict. 
// Uses themeQuartz exported from community package.

interface Employee {
    id: string;
    name: string;
    department: string;
    role: string;
    status: 'Active' | 'On Leave' | 'Terminated' | 'Contract';
    budget: number;
    completion: number;
    lastActive: Date;
    efficiency: number;
}

const DEPARTMENTS = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Legal', 'Operations'];
const ROLES = ['Associate', 'Senior', 'Lead', 'Manager', 'Director', 'VP'];
const STATUSES = ['Active', 'On Leave', 'Terminated', 'Contract'];

// Mock Data Generator
const generateData = (count: number): Employee[] => {
    const data: Employee[] = [];
    for (let i = 0; i < count; i++) {
        data.push({
            id: `EMP-${10000 + i}`,
            name: `Employee ${i + 1}`,
            department: DEPARTMENTS[Math.floor(Math.random() * DEPARTMENTS.length)],
            role: ROLES[Math.floor(Math.random() * ROLES.length)],
            status: STATUSES[Math.floor(Math.random() * STATUSES.length)] as any,
            budget: Math.floor(Math.random() * 100000) + 5000,
            completion: Math.floor(Math.random() * 100),
            lastActive: new Date(Date.now() - Math.floor(Math.random() * 10000000000)),
            efficiency: Math.random(),
        });
    }
    return data;
};

const EnterpriseGrid = () => {
    const gridRef = useRef<AgGridReact>(null);
    const [rowData, setRowData] = useState<Employee[]>([]);
    const [quickFilterText, setQuickFilterText] = useState('');
    const [selectedCount, setSelectedCount] = useState(0);
    const [totalBudget, setTotalBudget] = useState(0);

    useEffect(() => {
        setTimeout(() => {
            const data = generateData(2500);
            setRowData(data);
            setTotalBudget(data.reduce((acc, curr) => acc + curr.budget, 0));
        }, 500);
    }, []);

    const onExportClick = useCallback(() => {
        gridRef.current?.api.exportDataAsCsv();
    }, []);

    const onSelectionChanged = useCallback(() => {
        setSelectedCount(gridRef.current?.api.getSelectedRows().length || 0);
    }, []);

    // Custom Cell Renderer for Status
    const StatusRenderer = (params: any) => {
        const status = params.value;
        let colorClass = 'bg-gray-100 text-gray-800';
        if (status === 'Active') colorClass = 'bg-green-100 text-green-800';
        else if (status === 'On Leave') colorClass = 'bg-yellow-100 text-yellow-800';
        else if (status === 'Terminated') colorClass = 'bg-red-100 text-red-800';
        else if (status === 'Contract') colorClass = 'bg-blue-100 text-blue-800';

        return (
            <span className={`px-2 py-1 rounded-full text-xs font-semibold ${colorClass}`}>
                {status}
            </span>
        );
    };

    const ProgressRenderer = (params: any) => {
        const value = params.value;
        let color = 'bg-blue-600';
        if (value < 30) color = 'bg-red-500';
        else if (value < 70) color = 'bg-yellow-500';
        else color = 'bg-green-500';

        return (
            <div className="w-full bg-gray-200 rounded-full h-2.5 mt-3">
                <div className={`${color} h-2.5 rounded-full`} style={{ width: `${value}%` }}></div>
            </div>
        );
    };

    const currencyFormatter = (params: any) => {
        return '$' + params.value.toLocaleString();
    };

    // Row Class Rules for conditional styling
    const rowClassRules = useMemo<RowClassRules>(() => ({
        'bg-red-50': (params) => params.data.status === 'Terminated',
        'bg-yellow-50': (params) => params.data.budget < 20000 && params.data.status === 'Active',
    }), []);

    const colDefs = useMemo<ColDef[]>(() => [
        { field: 'id', headerName: 'ID', pinned: 'left', width: 120, filter: 'agTextColumnFilter', checkboxSelection: true, headerCheckboxSelection: true },
        { field: 'name', headerName: 'Name', filter: 'agTextColumnFilter', width: 180 },
        { field: 'department', headerName: 'Department', filter: 'agTextColumnFilter', width: 140 },
        { field: 'role', headerName: 'Role', filter: 'agTextColumnFilter', width: 140 },
        {
            field: 'status',
            cellRenderer: StatusRenderer,
            filter: 'agTextColumnFilter',
            width: 130
        },
        {
            field: 'budget',
            headerName: 'Budget',
            valueFormatter: currencyFormatter,
            filter: 'agNumberColumnFilter',
            type: 'rightAligned',
            width: 130
        },
        {
            field: 'completion',
            headerName: 'Completion',
            cellRenderer: ProgressRenderer,
            width: 160,
            filter: 'agNumberColumnFilter'
        },
        {
            field: 'lastActive',
            headerName: 'Last Active',
            filter: 'agDateColumnFilter',
            valueFormatter: (params: any) => params.value.toLocaleDateString(),
            minWidth: 140
        }
    ], []);

    const defaultColDef = useMemo(() => ({
        sortable: true,
        resizable: true,
        floatingFilter: true,
    }), []);

    // Updated row selection options per v33
    const rowSelection = useMemo<RowSelectionOptions>(() => ({
        mode: 'multiRow',
        checkboxes: true,
        headerCheckbox: true,
    }), []);

    return (
        <div className="flex flex-col gap-4 h-[650px] w-full">
            <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-200 flex flex-col sm:flex-row justify-between items-center gap-4">
                <div>
                    <h2 className="text-xl font-bold text-gray-800">Resource Monitor</h2>
                    <p className="text-gray-500 text-sm">2,500 Records Loaded | Enterprise Mode</p>
                </div>
                <div className="flex items-center gap-3 w-full sm:w-auto">
                    <input
                        type="text"
                        placeholder="Global search..."
                        className="border border-gray-300 rounded px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none w-full sm:w-64"
                        value={quickFilterText}
                        onChange={(e) => setQuickFilterText(e.target.value)}
                    />
                    <button
                        onClick={onExportClick}
                        className="bg-green-600 hover:bg-green-700 text-white text-sm font-medium px-4 py-2 rounded transition-colors whitespace-nowrap"
                    >
                        Export CSV
                    </button>
                </div>
            </div>

            <div className="flex-1 shadow-lg rounded-lg overflow-hidden border border-gray-200">
                <AgGridReact
                    ref={gridRef}
                    theme={themeQuartz}
                    rowData={rowData}
                    columnDefs={colDefs}
                    defaultColDef={defaultColDef}
                    pagination={true}
                    paginationPageSize={20}
                    paginationPageSizeSelector={[20, 50, 100]}
                    rowSelection={rowSelection}
                    quickFilterText={quickFilterText}
                    rowClassRules={rowClassRules}
                    onSelectionChanged={onSelectionChanged}
                    animateRows={true}
                />
            </div>

            <div className="bg-gray-800 text-white p-2 rounded-lg text-xs flex justify-between px-4 items-center">
                <span>Status: Online</span>
                <div className="flex gap-4">
                    <span>Selected: <b>{selectedCount}</b></span>
                    <span>Total Budget: <b>{currencyFormatter({ value: totalBudget })}</b></span>
                </div>
            </div>
        </div>
    );
};

export default EnterpriseGrid;
