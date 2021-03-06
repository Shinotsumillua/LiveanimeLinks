-- Forceful Deal
-- scripted by: UnknownGuest
--fixed by MLD
function c800000000.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c800000000.condition)
	e1:SetCost(c800000000.cost)
	e1:SetTarget(c800000000.target)
	e1:SetOperation(c800000000.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c800000000.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c800000000.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c800000000.cfilter,1,nil,tp)
end
function c800000000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	e:SetLabel(g:GetCount())
	if chk==0 then return g:GetCount()>0 and g:FilterCount(Card.IsReleasable,nil)==g:GetCount() end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Release(g,REASON_COST)
end
function c800000000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil,true)
	if chk==0 then
		local ct=e:GetLabel()
		e:SetLabel(0)
		return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)>=-ct+g:GetCount()
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
	e:SetLabel(0)
end
function c800000000.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil,true)
	Duel.GetControl(g,tp)
end
