'use client';

import { useState, useEffect, useRef } from 'react';
import { Bell, Check, Trash2, Clock, Info, CheckCircle2, AlertTriangle, ExternalLink } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { cn } from '@/lib/utils';
import Link from 'next/link';

export default function NotificationCenter() {
  const [isOpen, setIsOpen] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const dropdownRef = useRef(null);

  async function fetchNotifications() {
    try {
      const res = await fetch('/api/user/notifications');
      const data = await res.json();
      if (data.success) {
        setNotifications(data.notifications);
        setUnreadCount(data.notifications.filter(n => !n.is_read).length);
      }
    } catch (error) {
      console.error('Error fetching notifications:', error);
    }
  }

  useEffect(() => {
    fetchNotifications();
    // Poll for new notifications every 60 seconds
    const interval = setInterval(fetchNotifications, 60000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    function handleClickOutside(event) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const markAsRead = async (id) => {
    try {
      await fetch('/api/user/notifications', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id })
      });
      setNotifications(notifications.map(n => n.id === id ? { ...n, is_read: true } : n));
      setUnreadCount(prev => Math.max(0, prev - 1));
    } catch (error) {
      console.error('Error marking as read:', error);
    }
  };

  const markAllAsRead = async () => {
    try {
      await fetch('/api/user/notifications', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ all: true })
      });
      setNotifications(notifications.map(n => ({ ...n, is_read: true })));
      setUnreadCount(0);
    } catch (error) {
      console.error('Error marking all as read:', error);
    }
  };

  const getIcon = (type) => {
    switch (type) {
      case 'success': return <CheckCircle2 className="text-emerald-500" size={16} />;
      case 'warning': return <AlertTriangle className="text-amber-500" size={16} />;
      case 'error': return <AlertTriangle className="text-red-500" size={16} />;
      default: return <Info className="text-blue-500" size={16} />;
    }
  };

  return (
    <div className="relative" ref={dropdownRef}>
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="p-2.5 rounded-full bg-muted/30 dark:bg-white/5 text-secondary dark:text-white relative transition-all hover:scale-110"
      >
        <Bell size={20} />
        {unreadCount > 0 && (
          <span className="absolute top-2 right-2 w-4 h-4 bg-primary text-secondary text-[8px] font-black rounded-full border-2 border-white dark:border-zinc-900 flex items-center justify-center animate-bounce">
            {unreadCount}
          </span>
        )}
      </button>

      <AnimatePresence>
        {isOpen && (
          <motion.div 
            initial={{ opacity: 0, y: 10, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 10, scale: 0.95 }}
            className="absolute right-0 mt-4 w-80 md:w-96 bg-white dark:bg-zinc-900 rounded-[2rem] shadow-2xl border border-border/50 dark:border-white/5 overflow-hidden z-50"
          >
            <div className="p-6 border-b border-border/50 dark:border-white/5 flex items-center justify-between">
              <h3 className="text-sm font-black text-secondary dark:text-white uppercase tracking-widest">Notificaciones</h3>
              {unreadCount > 0 && (
                <button 
                  onClick={markAllAsRead}
                  className="text-[10px] font-black text-primary hover:underline uppercase tracking-tighter"
                >
                  Marcar todo como leído
                </button>
              )}
            </div>

            <div className="max-h-[400px] overflow-y-auto custom-scrollbar">
              {notifications.length > 0 ? (
                notifications.map((n) => (
                  <div 
                    key={n.id}
                    className={cn(
                      "p-5 border-b border-border/30 dark:border-white/5 transition-colors relative group",
                      !n.is_read ? "bg-primary/5 dark:bg-primary/5" : "hover:bg-muted/10 dark:hover:bg-white/5"
                    )}
                  >
                    {!n.is_read && <div className="absolute left-0 top-0 bottom-0 w-1 bg-primary" />}
                    
                    <div className="flex gap-4">
                      <div className="mt-1 shrink-0 p-2 rounded-xl bg-white dark:bg-zinc-800 shadow-sm border border-border/50 dark:border-white/5">
                        {getIcon(n.type)}
                      </div>
                      <div className="flex-1 space-y-1">
                        <div className="flex justify-between items-start">
                          <h4 className="text-xs font-black text-secondary dark:text-white leading-tight">{n.title}</h4>
                          <span className="text-[9px] font-bold text-muted-foreground whitespace-nowrap">
                            {new Date(n.created_at).toLocaleDateString([], { hour: '2-digit', minute: '2-digit' })}
                          </span>
                        </div>
                        <p className="text-[11px] text-muted-foreground font-medium leading-relaxed">{n.message}</p>
                        
                        <div className="flex items-center gap-3 mt-3">
                          {n.link && (
                            <Link 
                              href={n.link} 
                              onClick={() => { markAsRead(n.id); setIsOpen(false); }}
                              className="text-[10px] font-black text-primary flex items-center gap-1 hover:underline"
                            >
                              Ver <ExternalLink size={10} />
                            </Link>
                          )}
                          {!n.is_read && (
                            <button 
                              onClick={() => markAsRead(n.id)}
                              className="text-[10px] font-black text-muted-foreground hover:text-secondary dark:hover:text-white flex items-center gap-1"
                            >
                              <Check size={10} /> Marcar leído
                            </button>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                ))
              ) : (
                <div className="p-12 text-center">
                  <Bell className="mx-auto mb-4 text-muted-foreground opacity-20" size={48} />
                  <p className="text-xs font-bold text-muted-foreground">No tienes notificaciones aún.</p>
                </div>
              )}
            </div>

            <div className="p-4 bg-muted/10 dark:bg-white/5 text-center">
              <Link 
                href="/dashboard/mensajes" 
                className="text-[10px] font-black text-muted-foreground hover:text-secondary dark:hover:text-white uppercase tracking-widest"
              >
                Ver historial completo
              </Link>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
