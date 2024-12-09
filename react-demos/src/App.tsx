import {useComplexThingValue, ComplexState, ComplexThingContext } from './useComplexThing';
import PersonManager from './components/PersonManager';
import CounterManager from './components/CounterManager';
import { MyContextProvider } from './myContext';

const INITIAL_STATE: ComplexState = {
  counter: 0,
  people: [
    { name: 'Alice', age: 20 },
    { name: 'Bob', age: 34 },
  ]
};

function App() {
  // Create an instance of the API
  const complexThingValue = useComplexThingValue(INITIAL_STATE);

  // Use the Provider to make it available to all children
  return (
    <MyContextProvider>
      <ComplexThingContext.Provider value={complexThingValue}>
        <h1>Reducer Demo</h1>
        <CounterManager />
        <PersonManager />
      </ComplexThingContext.Provider>
    </MyContextProvider>
  )
}

export default App
