import React from 'react';

interface Person {
  name: string;
  age: number;
}

export interface ComplexState {
  counter: number;
  people: Person[];
}

export const DEFAULT_COMPLEX_STATE: ComplexState = {
  counter: 0,
  people: []
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
interface RemovePerson extends IAction {
  type: 'removePerson',
  name: string
}
interface HandleMyFunction extends IAction {
  type: 'handleMyFunction',
  myFunction: (message: string) => void,
}
interface ChangeStateSomehow extends IAction {
  type: 'changeStateSomehow',
  data: string
}

type Action = IncrementAge | IncrementCounter | CreateNewAdult | RemovePerson | HandleMyFunction | ChangeStateSomehow;

function reducer(state: ComplexState, action: Action): ComplexState {
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
    case 'removePerson': {
      return {
        ...state,
        people: state.people.filter(p => p.name !== action.name)
      }
    }
    case 'handleMyFunction': {
      action.myFunction("you are calling this from the complexThing context");
      return state;
    }
    case 'changeStateSomehow': {
      console.log(action.data)
      // update state with data

      return {
        ...state,
      }
    }
  }
}

/**
 * This becomes the API for the custom hook.
 * Expressed in terms that are specific to the problem space.
 */
export interface UseComplexThing {
  state: ComplexState;
  incrementCounter: () => void;
  incrementAge: (name: string) => void;
  createNewAdult: (name: string) => void;
  removePerson: (name: string) => void;
  anotherFunction: (myFunction: (message: string) => void) => void;
  changeStateSomehow: (data: string) => void;
}

/**
 * This is the custom hook itself, it manages the reducer, creates the handlers and returns the nice API
 * It constructs a value for the ComplexThingApi which we can then pass down in a context.
 * But...in itself, it is not aware it might be used that way.
  */
export function useComplexThingValue(defaultState: ComplexState): UseComplexThing {
  const [state, dispatch] = React.useReducer(reducer, defaultState);

  const incrementCounter = React.useCallback(() => dispatch({type: 'incrementCounter'}), []);
  const incrementAge = React.useCallback((name: string) => dispatch({type: 'incrementAge', name}), []);
  const createNewAdult = React.useCallback((name: string) => dispatch({type: 'createNewAdult', name}), []);
  const removePerson = React.useCallback((name: string) => dispatch({type: 'removePerson', name}), []);
  const anotherFunction = React.useCallback((myFunction: (message: string) => void) => dispatch({type: 'handleMyFunction', myFunction}), []);
  const changeStateSomehow = React.useCallback((data: string) => dispatch({type: "changeStateSomehow", data}), []);

  return {
    state,
    incrementCounter,
    incrementAge,
    createNewAdult,
    removePerson,
    anotherFunction,
    changeStateSomehow
  }
}

/**
 * Create the idea of UseComplexThing being a context.
 */
export const ComplexThingContext = React.createContext<UseComplexThing>({
  state: DEFAULT_COMPLEX_STATE,
  incrementAge: () => console.error('Not implemented in default value'),
  incrementCounter: () => console.error('Not implemented in default value'),
  createNewAdult: () => console.error('Not implemented in default value'),
  removePerson: () => console.error('Not implemented in default value'),
  anotherFunction: () => console.error('Not yet'),
  changeStateSomehow: () => console.error("not yet either")
});

/**
 * This is just a convenience function for accessing the context.
 */
export const useComplexThing = () => React.useContext(ComplexThingContext);

