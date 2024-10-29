import React from 'react'

import {useComplexThingValue, ComplexState, ComplexThingContext } from './useComplexThing';
import CounterDisplay from './components/CounterDisplay';
import CounterIncrementButton from './components/CounterIncrementButton';
import PeopleTable from './components/PeopleTable';
import AddNewPersonForm from './components/AddNewPersonForm';

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
  return (<ComplexThingContext.Provider value={complexThingValue}>
    <h1>Reducer Demo</h1>
    <CounterDisplay />
    <CounterIncrementButton />
    <PeopleTable />
    <AddNewPersonForm />
  </ComplexThingContext.Provider>
  )
}

export default App
