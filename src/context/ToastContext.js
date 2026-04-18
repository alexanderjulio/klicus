'use client';

import React, { createContext, useContext, useState, useCallback } from 'react';
import Notification from '@/components/ui/Notification';
import { AnimatePresence } from 'framer-motion';

const ToastContext = createContext(null);

export const useToast = () => {
  const context = useContext(ToastContext);
  if (!context) {
    throw new Error('useToast debe ser usado dentro de un ToastProvider');
  }
  return context;
};

export const ToastProvider = ({ children }) => {
  const [toasts, setToasts] = useState([]);

  const showToast = useCallback((message, type = 'info', duration = 4000) => {
    const id = Math.random().toString(36).substring(2, 9);
    setToasts((prev) => [...prev, { id, message, type }]);

    setTimeout(() => {
      setToasts((prev) => prev.filter((toast) => toast.id !== id));
    }, duration);
  }, []);

  const removeToast = useCallback((id) => {
    setToasts((prev) => prev.filter((toast) => toast.id !== id));
  }, []);

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
      <div className="fixed bottom-12 left-1/2 -translate-x-1/2 z-[9999] flex flex-col-reverse gap-3 pointer-events-none">
        <AnimatePresence>

          {toasts.map((toast) => (
            <Notification 
              key={toast.id} 
              {...toast} 
              onClose={() => removeToast(toast.id)} 
            />
          ))}
        </AnimatePresence>
      </div>
    </ToastContext.Provider>
  );
};
