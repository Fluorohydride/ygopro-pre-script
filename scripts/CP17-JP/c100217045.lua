--Ｎｏ．８９ 電脳獣ディアブロシス
--Number 89: Computerbeast Diablosis
--Scripted by Sahim
function c100217045.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--banish extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100217045,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100217045.excost)
	e1:SetOperation(c100217045.exop)
	c:RegisterEffect(e1)	
	--banish grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100217045,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100217045.grcon)
	e2:SetTarget(c100217045.grtg)
	e2:SetOperation(c100217045.grop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetOperation(c100217045.regop)
	c:RegisterEffect(e3)	
	--banish deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100217045,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c100217045.dkcon)
	e4:SetTarget(c100217045.dktg)
	e4:SetOperation(c100217045.dkop)
	c:RegisterEffect(e4)
end
c100217045.xyz_number=89
function c100217045.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100217045.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c100217045.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(100217045,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c100217045.grcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100217045)~=0
end
function c100217045.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100217045.grop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
end
function c100217045.dkfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFacedown()
end
function c100217045.dkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100217045.dkfilter,1,nil)
end
function c100217045.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local n=Duel.GetMatchingGroupCount(c100217045.dkfilter,tp,0,LOCATION_REMOVED,nil)
	if chk==0 then return n>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,n,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,n,0,0)
end
function c100217045.dkop(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetMatchingGroupCount(c100217045.dkfilter,tp,0,LOCATION_REMOVED,nil)
	if n==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetDecktopGroup(1-tp,n)
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end