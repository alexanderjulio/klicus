'use client';

import React, { createContext, useContext, useState, useEffect } from 'react';

const LocationContext = createContext();

export const LocationProvider = ({ children }) => {
  const [selectedCity, setSelectedCity] = useState('Todas');
  const [isInitialized, setIsInitialized] = useState(false);

  // Load from localStorage on init
  useEffect(() => {
    const savedCity = localStorage.getItem('klicus_city');
    if (savedCity) {
      setSelectedCity(savedCity);
    }
    setIsInitialized(true);
  }, []);

  // Save to localStorage when changed
  useEffect(() => {
    if (isInitialized) {
      localStorage.setItem('klicus_city', selectedCity);
    }
  }, [selectedCity, isInitialized]);

  return (
    <LocationContext.Provider value={{ selectedCity, setSelectedCity, isInitialized }}>
      {children}
    </LocationContext.Provider>
  );
};

export const useLocation = () => {
  const context = useContext(LocationContext);
  if (!context) {
    throw new Error('useLocation must be used within a LocationProvider');
  }
  return context;
};
