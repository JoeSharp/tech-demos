import React from 'react'

import useComplexThing, { ComplexState } from './useComplexThing';

const INITIAL_STATE: ComplexState = {
  counter: 0,
  people: [
    { name: 'Alice', age: 20 },
    { name: 'Bob', age: 34 },
  ]
};

function App() {
  const {state, incrementCounter, incrementAge, createNewAdult } = useComplexThing(INITIAL_STATE);
  const [newName, setNewName] = React.useState('charlie');

  const onNewNameChange: React.ChangeEventHandler<HTMLInputElement> = React.useCallback(e => {
    setNewName(e.target.value);
  }, []);

  return (<div>
      <h1>Reducer Demo</h1>
      <h2>Counter</h2>
      <p>Value: {state.counter}</p>
      <button onClick={incrementCounter}>Increment</button>

      <h2>People</h2>
      <table>
        <thead>
          <tr><th>Name</th><th>Age</th><th>Increment</th></tr>
        </thead>
        <tbody>
          {state.people.map(person => (<tr key={person.name}>
            <td>{person.name}</td>
              <td>{person.age}</td>
              <td><button onClick={() => incrementAge(person.name)}>Birthday!</button></td>
            </tr>
          ))}
        </tbody>
      </table>

      <div>
      <label>New Name</label>
      <input type="text" value={newName} onChange={onNewNameChange} />
      <button onClick={() => createNewAdult(newName)}>Add</button>
      </div>
    </div>
  )
}

export default App
