import React from 'react';

interface Person {
  name: string;
  age: number;
}

export interface ComplexState {
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

/**
 * This becomes the API for the custom hook.
 * Expressed in terms that are specific to the problem space.
 */
export interface UseComplexThing {
  state: ComplexState;
  incrementCounter: () => void;
  incrementAge: (name: string) => void;
  createNewAdult: (name: string) => void;
}

/**
 * This is the custom hook itself, it manages the reducer, creates the handlers and returns the nice API
  */
function useComplexThing(defaultState: ComplexState): UseComplexThing {
  const [state, dispatch] = React.useReducer(reducer, defaultState);

  const incrementCounter = React.useCallback(() => dispatch({type: 'incrementCounter'}), []);
  const incrementAge = React.useCallback((name: string) => dispatch({type: 'incrementAge', name}), []);
  const createNewAdult = React.useCallback((name: string) => dispatch({type: 'createNewAdult', name}), []);

  return {
    state,
    incrementCounter,
    incrementAge,
    createNewAdult
  }
}

export default useComplexThing;
