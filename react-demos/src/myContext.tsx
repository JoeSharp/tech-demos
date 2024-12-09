import React, { createContext, useContext, ReactNode } from "react";

interface MyContextValue {
    func: (message: string) => void;
    func2: (fn: (m: string) => void) => void;
}

function useMyContextValue(): MyContextValue {
    // let ws = new WebSocket()

    const handlers: Array<(m: string) => void> = [];

    function func(message: string): void {
        // "send" the message - in reality over websocket, the reference for which is kept within this function
        // ws.send(message)
        console.log(message);
    }

    function func2(fn: (m: string) => void) {
        handlers.push(fn)
    }
    
    // something like this to call each handler:

    // ws.onmessage = (e) => {
    //     handlers.forEach(fn => fn(e.data))
    // }

    return {
        func,
        func2,
    };
}

const MyContext = createContext<MyContextValue | null>(null);

interface MyContextProviderProps {
    children: ReactNode;
}

export const MyContextProvider: React.FC<MyContextProviderProps> = ({ children }) => {
    const contextValue = useMyContextValue();

    return (
        <MyContext.Provider value={contextValue}>
            {children}
        </MyContext.Provider>
    );
};

export const useMyContext = (): MyContextValue => {
    const context = useContext(MyContext);
    if (!context) {
        throw new Error("useMyContext must be used within a MyContextProvider");
    }
    return context;
};
