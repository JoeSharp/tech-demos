import React, { createContext, useContext, ReactNode } from "react";

interface MyContextValue {
    func: (message: string) => void;
}

function useMyContextValue(): MyContextValue {
    let savedMessage: string = "";


    // use this function to update a variable in the contextValue
    // in reality, this type of function is being used to add message handlers to a socket service,
    // with the websocket object held in the MyContextValue object.
    function func(message: string): void {
        savedMessage = message
        console.log(savedMessage);
    }

    return {
        func,
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
