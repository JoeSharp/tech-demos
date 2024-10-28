import React from 'react'

interface Person {
  name: string;
  age: number;
}

interface ComplexState {
  counter: number;
  people: Person[];
}

interface IAction {
  type: string;
}

interface IncrementCounter extends IAction {
  type: 'incrementCounter'
}

interface IncrementAge extends IAction {
  type: 'incrementAge',
  name: string
}

interface CreateNewAdult extends IAction {
  type: 'createNewAdult',
  name: string
}

function reducer(state: ComplexState, action: IAction): ComplexState {
  switch(action.type) {
    case 'incrementCounter': {
      return {
        ...state,
        counter: state.counter + 1
      }
    }
    case 'incrementAge': {
      return {
        ...state,
        people: state.people.map(person => person.name === action.name ? ({
          ...person,
          age: person.age + 1
        }) : person)
      }
    }
    case 'createNewAdult': {
      return {
        ...state,
        people: [...state.people, {name: action.name, age: 18}]
      }
    }
  }

  return state;
}

const INITIAL_STATE: ComplexState = {
  counter: 0,
  people: [
    { name: 'Alice', age: 20 },
    { name: 'Bob', age: 34 },
  ]
};

function App() {
  const [state, dispatch] = React.useReducer(reducer, INITIAL_STATE);
  const [newName, setNewName] = React.useState('charlie');

  const onNewNameChange: React.ChangeEventHandler<HTMLInputElement> = React.useCallback(e => {
    setNewName(e.target.value);
  }, []);

  return (<div>
      <h1>Reducer Demo</h1>
      <h2>Counter</h2>
      <p>Value: {state.counter}</p>
      <button onClick={() => dispatch({type: 'incrementCounter'})}>Increment</button>

      <h2>People</h2>
      <table>
        <thead>
          <tr><th>Name</th><th>Age</th><th>Increment</th></tr>
        </thead>
        <tbody>
          {state.people.map(person => (<tr key={person.name}>
            <td>{person.name}</td>
              <td>{person.age}</td>
              <td><button onClick={() => dispatch({type: 'incrementAge', name: person.name})}>Birthday!</button></td>
            </tr>
          ))}
        </tbody>
      </table>

      <div>
      <label>New Name</label>
      <input type="text" value={newName} onChange={onNewNameChange} />
      <button onClick={() => dispatch({type: 'createNewAdult', name: newName})}>Add</button>
      </div>
    </div>
  )
}

export default App
