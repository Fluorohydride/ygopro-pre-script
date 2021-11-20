--Beetrooper Assault Roller
--Scripted by: XGlitchy30
function c101106085.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101106085+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101106085.spcon)
	e1:SetOperation(c101106085.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c101106085.atkup)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCountLimit(1,101106085+100)
	e3:SetTarget(c101106085.sctg)
	e3:SetOperation(c101106085.scop)
	c:RegisterEffect(e3)
end
function c101106085.spcostfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_INSECT)
end
function c101106085.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c101106085.spcostfilter1,tp,LOCATION_GRAVE,0,nil)
	return #g>0
end
function c101106085.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c101106085.spcostfilter1,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end
function c101106085.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c101106085.atkup(e,c)
	return Duel.GetMatchingGroupCount(c101106085.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())*200
end
function c101106085.filter(c)
	return c:IsSetCard(0x170) and c:IsType(TYPE_MONSTER) and not c:IsCode(101106085) and c:IsAbleToHand()
end
function c101106085.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106085.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101106085.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101106085.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
