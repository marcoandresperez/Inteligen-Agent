/**
 * @file agent.pl
 * @brief Agente Inteligente: Optimizador de Itinerarios de Viaje
 *
 * Este módulo implementa un agente inteligente que optimiza itinerarios de viaje
 * entre atracciones turísticas, utilizando una búsqueda recursiva en un espacio de estados.
 *
 * Predicados exportados:
 *   - itinerario/4: Encuentra un itinerario entre dos atracciones, calculando el costo total.
 *
 * Uso:
 *   Cargar el módulo en SWI-Prolog:
 *       ?- [agent].
 *   Consultar un itinerario:
 *       ?- itinerario(laSagradaFamilia, museoPicasso, Itinerario, CostoTotal).
 */

:- module(agent, [itinerario/4]).

/* ===========================================================================
   Declaración de hechos: Definición de atracciones y conexiones
   =========================================================================== */

/** 
 * Hechos: Definición de atracciones turísticas.
 */
atraccion(laSagradaFamilia).
atraccion(parkGuell).
atraccion(museoPicasso).

/**
 * Hechos: Conexiones entre atracciones.
 * La relación conectado(X, Y, C) indica que existe un camino de la atracción X a la Y
 * con un costo C (por ejemplo, en minutos).
 */
conectado(laSagradaFamilia, parkGuell, 15).
conectado(parkGuell, museoPicasso, 10).
conectado(laSagradaFamilia, museoPicasso, 20).

/* ===========================================================================
   Predicados para la búsqueda de itinerarios
   =========================================================================== */

/**
 * itinerario(+Inicio, +Objetivo, -Itinerario, -CostoTotal)
 *
 * Encuentra un itinerario desde la atracción Inicio hasta la atracción Objetivo.
 * Itinerario es una lista de atracciones que representa el camino recorrido (en orden).
 * CostoTotal es la suma acumulada de los costos de cada tramo del itinerario.
 *
 * @param Inicio       Atracción de inicio.
 * @param Objetivo     Atracción destino.
 * @param Itinerario   Lista de atracciones que conforman el itinerario.
 * @param CostoTotal   Costo acumulado del itinerario.
 */
itinerario(Inicio, Objetivo, Itinerario, CostoTotal) :-
    itinerario_rec(Inicio, Objetivo, [Inicio], ItinerarioReversed, 0, CostoTotal),
    reverse(ItinerarioReversed, Itinerario).

/**
 * itinerario_rec(+Actual, +Objetivo, +Camino, -Itinerario, +CostoAcum, -CostoTotal)
 *
 * Predicado recursivo que explora conexiones para encontrar un itinerario desde la
 * atracción Actual hasta la atracción Objetivo. Camino es la lista acumulada de
 * atracciones visitadas (en orden inverso).
 *
 * @param Actual       Atracción actual.
 * @param Objetivo     Atracción destino.
 * @param Camino       Lista acumulada de atracciones visitadas (orden inverso).
 * @param Itinerario   Itinerario resultante (orden inverso).
 * @param CostoAcum    Costo acumulado hasta el momento.
 * @param CostoTotal   Costo total del itinerario.
 */
itinerario_rec(Objetivo, Objetivo, Camino, Camino, Costo, Costo) :- !.

itinerario_rec(Actual, Objetivo, Camino, Itinerario, CostoAcum, CostoTotal) :-
    conectado(Actual, Prox, CostoPaso),
    \+ member(Prox, Camino),
    NuevoCosto is CostoAcum + CostoPaso,
    itinerario_rec(Prox, Objetivo, [Prox|Camino], Itinerario, NuevoCosto, CostoTotal).
