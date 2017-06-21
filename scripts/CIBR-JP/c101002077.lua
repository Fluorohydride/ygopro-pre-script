--拮抗勝負
--Struggling Battle
--Scripted by Eerie Code
function c101002077.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetTarget(c101002077.target)
	e1:SetOperation(c101002077.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c101002077.handcon)
	c:RegisterEffect(e2)
end
function c101002077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,POS_FACEDOWN)
	local gc=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if chk==0 then return g:GetCount()>0 and gc>0 and gc<=g:GetCount() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
end
function c101002077.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,POS_FACEDOWN)
	local gc=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if g:GetCount()>0 and gc>0 and gc<=g:GetCount() then
		local sg=g:Select(1-tp,gc,gc,nil)
		if sg:GetCount()>0 then
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c101002077.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
