;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;;;
;;; pkgdcl.lisp --- Package definition.
;;;
;;; Copyright (C) 2006-2008, Stelian Ionescu  <sionescu@common-lisp.net>
;;;
;;; This code is free software; you can redistribute it and/or
;;; modify it under the terms of the version 2.1 of
;;; the GNU Lesser General Public License as published by
;;; the Free Software Foundation, as clarified by the
;;; preamble found here:
;;;     http://opensource.franz.com/preamble.html
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General
;;; Public License along with this library; if not, write to the
;;; Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
;;; Boston, MA 02110-1301, USA

(in-package :common-lisp-user)

(defpackage :net.sockets
  (:nicknames #:sockets)
  (:use #:common-lisp :cffi :alexandria :split-sequence :io.streams :series)
  (:import-from #:osicat-posix #:system-error #:posix-error
                #:system-error-message #:errno-wrapper
                #:pid #:gid #:uid #:size #:ssize #:bzero
                #:timeval #:size-of-timeval #:sec #:usec)
  (:import-from #:osicat-sys #:size-of-int)
  (:shadow #:let #:let* #:multiple-value-bind #:funcall #:defun)
  (:export
   ;; Conditions
   #:posix-error
   #:possible-bug
   #:resolver-error
   #:resolver-again-error
   #:resolver-fail-error
   #:resolver-no-name-error
   #:resolver-unknown-error
   #:socket-address-in-use-error
   #:socket-address-not-available-error
   #:socket-already-connected-error
   #:socket-connection-aborted-error
   #:socket-connection-refused-error
   #:socket-connection-reset-error
   #:socket-connection-timeout-error
   #:socket-endpoint-shutdown-error
   #:socket-error
   #:socket-host-down-error
   #:socket-host-unreachable-error
   #:socket-network-down-error
   #:socket-network-reset-error
   #:socket-network-unreachable-error
   #:socket-no-buffer-space-error
   #:socket-no-network-error
   #:socket-not-connected-error
   #:socket-operation-not-supported-error
   #:socket-option-not-supported-error
   #:system-error
   #:unknown-interface
   #:unknown-protocol
   #:unknown-service

   ;; Condition Accessors
   #:address-type
   #:bug-data
   #:error-code
   #:error-identifier
   #:error-message
   #:resolver-error-data
   #:unknown-protocol-name
   #:unknown-service-name

   ;; Low-level Address Conversion
   #:address-to-vector
   #:colon-separated-to-vector
   #:dotted-to-integer
   #:dotted-to-vector
   #:integer-to-dotted
   #:integer-to-vector
   #:string-address-to-vector
   #:vector-to-colon-separated
   #:vector-to-dotted
   #:vector-to-integer
   #:map-ipv4-address-to-ipv6
   #:map-ipv6-address-to-ipv4

   ;; Address Classes
   #:address
   #:inet-address
   #:ipv4-address
   #:ipv6-address
   #:local-address

   ;; Address Functions
   #:address-equal-p
   #:address-name
   #:address-to-string
   #:address=
   #:copy-address
   #:ensure-address
   #:make-address

   ;; Well-known Addresses
   #:+ipv4-loopback+
   #:+ipv4-unspecified+
   #:+ipv6-interface-local-all-nodes+
   #:+ipv6-interface-local-all-routers+
   #:+ipv6-link-local-all-nodes+
   #:+ipv6-link-local-all-routers+
   #:+ipv6-loopback+
   #:+ipv6-site-local-all-routers+
   #:+ipv6-unspecified+
   #:+max-ipv4-value+
   #:+any-host+
   #:+loopback+

   ;; Address Predicates
   #:abstract-address-p
   #:addressp
   #:inet-address-loopback-p
   #:inet-address-multicast-p
   #:inet-address-p
   #:inet-address-type
   #:inet-address-unicast-p
   #:inet-address-unspecified-p
   #:ipv4-address-p
   #:ipv6-address-p
   #:ipv6-admin-local-multicast-p
   #:ipv6-global-multicast-p
   #:ipv6-global-unicast-p
   #:ipv6-interface-local-multicast-p
   #:ipv6-ipv4-mapped-p
   #:ipv6-link-local-multicast-p
   #:ipv6-link-local-unicast-p
   #:ipv6-multicast-type
   #:ipv6-organization-local-multicast-p
   #:ipv6-reserved-multicast-p
   #:ipv6-site-local-multicast-p
   #:ipv6-site-local-unicast-p
   #:ipv6-solicited-node-multicast-p
   #:ipv6-transient-multicast-p
   #:ipv6-unassigned-multicast-p
   #:ipv6-unicast-type
   #:local-address-p

   ;; Network masks and subnets
   #:make-subnet-mask
   #:inet-address-private-p
   #:inet-address-network-portion
   #:inet-address-host-portion
   #:inet-address-in-network-p
   #:inet-addresses-in-same-network-p
   #:inet-address-network-class

   ;; Hostname, Service, and Protocol Lookups
   #:ensure-hostname
   #:lookup-host
   #:lookup-protocol
   #:lookup-service

   ;; Network Interface Lookup
   #:list-network-interfaces
   #:interface
   #:interface-index
   #:interface-name
   #:lookup-interface
   #:make-interface
   #:unknown-interface-datum

   ;; Socket Classes
   #:active-socket
   #:datagram-socket
   #:internet-socket
   #:local-socket
   #:passive-socket
   #:socket
   #:socket-datagram-internet-active
   #:socket-datagram-local-active
   #:socket-stream-internet-active
   #:socket-stream-internet-passive
   #:socket-stream-local-active
   #:socket-stream-local-passive
   #:stream-socket

   ;; Socket Methods
   #:accept-connection
   #:bind-address
   #:connect
   #:disconnect
   #:listen-on
   #:local-filename
   #:local-host
   #:local-name
   #:local-port
   #:make-socket
   #:make-socket-from-fd
   #:receive-from
   #:remote-filename
   #:remote-host
   #:remote-name
   #:remote-port
   #:send-to
   #:shutdown
   #:socket-connected-p
   #:socket-family
   #:socket-open-p
   #:socket-option
   #:socket-os-fd
   #:socket-protocol
   #:socket-type
   #:with-open-socket
   #:with-accept-connection

   ;; Specials
   #:*default-backlog-size*
   #:*default-linger-seconds*
   #:*ipv6*
   #:*dns-nameservers*
   #:*dns-domain*
   #:*dns-search-domain*
   ))

(in-package :net.sockets)

(series::install)
(setf series:*suppress-series-warnings* t)
